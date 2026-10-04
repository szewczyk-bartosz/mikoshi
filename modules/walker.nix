{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
  gtkColors = config.flake.lib.gtkColors;
in {
  flake.modules.nixos.walker = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.mikoshi.walker;
  in {
    options.mikoshi.walker = {
      enable = lib.mkEnableOption "Walker launcher";
    };
    config = lib.mkIf cfg.enable {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.walker;

      environment.systemPackages = with pkgs; [
        # elephant's clipboard provider watches via wl-paste, sizes images via identify
        wl-clipboard
        imagemagick
      ];
    };
  };

  flake.modules.homeManager.walker = {osConfig, ...}: let
    palette = (import ./_palette.nix).${osConfig.mikoshi.theme.polarity};
    sessionUnit = {
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
  in {
    config = {
      services.elephant.enable = true;
      systemd.user.services.elephant.Unit = sessionUnit;

      # resident walker opens instantly; it Requires elephant.service
      services.walker = {
        enable = true;
        systemd.enable = true;
        # on-demand layer-shell focus only arrives on click under sway
        settings.force_keyboard_focus = true;
        settings.providers = {
          default = ["desktopapplications"];
          empty = ["desktopapplications"];
          prefixes = [
            {
              prefix = "=";
              provider = "calc";
            }
            {
              prefix = "/";
              provider = "files";
            }
            {
              prefix = ":";
              provider = "clipboard";
            }
          ];
        };
        # replaces walker's default stylesheet entirely; `all: unset` keeps the
        # GTK theme out, the default layout is kept
        theme = {
          name = "mikoshi";
          style =
            gtkColors palette
            + ''
              * {
                all: unset;
              }

              popover {
                background: @surface;
                border-radius: 16px;
                padding: 8px;
              }

              .normal-icons {
                -gtk-icon-size: 16px;
              }

              .large-icons {
                -gtk-icon-size: 32px;
              }

              scrollbar {
                opacity: 0;
              }

              .box-wrapper {
                min-width: 640px;
                background: alpha(@base, 0.8);
                padding: 16px;
                border-radius: 16px;
              }

              .preview-box,
              .elephant-hint,
              .placeholder,
              .list {
                color: @text;
              }

              .input {
                caret-color: @text;
                background: alpha(@surface, 0.6);
                padding: 8px 16px;
                border-radius: 12px;
                color: @text;
              }

              .input placeholder {
                color: @muted;
              }

              .input selection {
                background: alpha(@accent, 0.4);
              }

              .item-box {
                border-radius: 12px;
                padding: 8px;
              }

              child:selected .item-box,
              row:selected .item-box {
                background: alpha(@accent, 0.25);
              }

              .item-quick-activation {
                background: alpha(@surface, 0.6);
                border-radius: 8px;
                padding: 8px;
              }

              .item-subtext {
                font-size: 12px;
                color: @muted;
              }

              .item-image-text {
                font-size: 28px;
              }

              .calc .item-text {
                font-size: 24px;
              }

              .preview {
                border: 1px solid alpha(@muted, 0.25);
                border-radius: 12px;
                color: @text;
              }

              .preview .large-icons {
                -gtk-icon-size: 64px;
              }

              .keybinds {
                padding-top: 8px;
                border-top: 1px solid alpha(@muted, 0.25);
                font-size: 12px;
                color: @muted;
              }

              .keybind-label {
                padding: 2px 4px;
                border-radius: 4px;
                border: 1px solid @muted;
              }

              .error {
                padding: 8px;
                border-radius: 12px;
                background: @danger;
                color: @base;
              }
            '';
        };
      };
      systemd.user.services.walker.Unit = sessionUnit;

      # providers load automatically when installed; keep only the ones walker
      # uses (desktopapplications, calc, files, clipboard) plus menus and
      # providerlist, which walker's action system relies on internally.
      # written by hand: elephant reads elephant.toml, services.elephant.settings
      # writes config.toml
      xdg.configFile."elephant/elephant.toml".text = ''
        # launched apps get their own systemd scope instead of living in elephant's
        launch_prefix = "uwsm app --"

        ignored_providers = [
          "1password",
          "archlinuxpkgs",
          "bitwarden",
          "bluetooth",
          "bookmarks",
          "dnfpackages",
          "niriactions",
          "nirisessions",
          "playerctl",
          "runner",
          "snippets",
          "symbols",
          "todo",
          "unicode",
          "websearch",
          "windows",
          "wireplumber",
        ]
      '';
    };
  };
}
