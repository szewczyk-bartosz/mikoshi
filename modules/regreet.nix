{config, ...}: let
  gtkColors = config.flake.lib.gtkColors;
in {
  flake.modules.nixos.regreet = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.programs.regreet;
    polarity = config.mikoshi.theme.polarity;
    palette = (import ./_palette.nix).${polarity};
    # regreet keeps the first <dir>/wayland-sessions/<file> it finds and skips
    # NoDisplay ones, so shadowing sway.desktop leaves only "Sway (UWSM)"
    hiddenSessions = pkgs.writeTextDir "share/wayland-sessions/sway.desktop" ''
      [Desktop Entry]
      Name=Sway
      Type=Application
      NoDisplay=true
    '';
    # the regreet module's default command, with hiddenSessions searched first
    greeter = pkgs.writeShellScript "mikoshi-greeter" ''
      export XDG_DATA_DIRS=${hiddenSessions}/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}
      exec ${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.cage} ${lib.escapeShellArgs cfg.cageArgs} -- ${lib.getExe cfg.package}
    '';
  in {
    options.mikoshi.regreet.enable = lib.mkEnableOption "ReGreet login screen";

    config = lib.mkIf config.mikoshi.regreet.enable {
      services.greetd.settings.default_session.command = greeter;

      programs.regreet = {
        enable = true;
        # the default `-m extend` spans all outputs in cage's own order, cutting
        # the greeter across monitors; keep it on one
        cageArgs = ["-s" "-d" "-m" "last"];
        font = {
          package = pkgs.nunito;
          name = "Nunito";
          size = 14;
        };
        iconTheme = {
          package = pkgs.whitesur-icon-theme;
          name = "WhiteSur-${polarity}";
        };
        cursorTheme = {
          package = pkgs.whitesur-cursors;
          name = "WhiteSur-cursors";
        };
        settings = {
          GTK.application_prefer_dark_theme = polarity == "dark";
          appearance.greeting_msg = "Welcome back";
          widget.clock.format = "%a %d %b  %H:%M";
        };
        extraCss =
          gtkColors palette
          + ''
            /* layers: base backdrop, overlay cards, base fields inset into them */
            window {
              background-image: linear-gradient(to bottom, @base, mix(@base, @accent, 0.08));
              color: @text;
            }

            frame.background {
              background-color: @overlay;
              border: 1px solid @subtle;
              border-radius: 16px;
              padding: 16px;
              box-shadow: 0 8px 24px alpha(black, 0.18);
            }

            grid > label {
              color: @muted;
            }

            /* the greeting */
            grid > label:first-child {
              color: @text;
            }

            entry,
            combobox button.combo {
              background: @base;
              color: @text;
              border: 1px solid @subtle;
              border-radius: 12px;
              box-shadow: none;
            }

            entry:focus-within {
              border-color: @accent;
              outline: 2px solid alpha(@accent, 0.4);
            }

            button {
              background: @surface;
              color: @text;
              border: 1px solid @subtle;
              border-radius: 12px;
              box-shadow: none;
            }

            button:hover,
            button:checked {
              background: @subtle;
            }

            button.suggested-action {
              background: @accent;
              color: @base;
              border-color: @accent;
            }

            button.suggested-action:hover {
              background: shade(@accent, 1.08);
            }

            /* power buttons: same as any other button, not alarming */
            button.destructive-action {
              background: @overlay;
            }

            button.destructive-action:hover {
              background: @surface;
            }

            infobar.error > revealer > box {
              background-color: @danger;
              color: @base;
              border-radius: 12px;
            }
          '';
      };
    };
  };
}
