{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
in {
  flake.modules.nixos.sway = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.mikoshi.wm.sway;
    palette = (import ./_palette.nix).${config.mikoshi.theme.polarity};
    altTabDaemon = pkgs.writers.writePython3Bin "mikoshiAltTabDaemon" {libraries = [pkgs.python3Packages.i3ipc];} ''
    import i3ipc
    import os
    import subprocess

    ipc = i3ipc.Connection()

    state_file = os.path.expanduser("~/.cache/mikoshi-alttabworkspace")
    os.makedirs(os.path.dirname(state_file), exist_ok=True)

    with open(state_file, "w") as f:
        f.write("1:1")


    def on_output(ipc, event):
        focused = [i for i in ipc.get_workspaces() if i.focused]
        if focused:
            n = focused[0].name.partition(":")[0]
            binpath = "${mikoshiWorkspaceSwitcher}/bin/msw"
            subprocess.run([binpath, n])


    def on_workspace(ipc, event):
        if event.change == 'focus' and event.old:
            old = event.old.name  # the workspace you just left
            new = event.current.name
            # extract N from "N:j"
            prev_n = old.partition(":")[0]
            new_n = new.partition(":")[0]
            if prev_n != new_n:
                with open(state_file, "w") as f:
                    f.write(old)


    ipc.on("workspace", on_workspace)
    ipc.on("output", on_output)
    ipc.main()
    '';
    mikoshiAltTab = pkgs.writeShellApplication {
      name = "mikoshiAltTab";
      runtimeInputs = [ mikoshiWorkspaceSwitcher ];
      text = ''
      prev=$(cat ~/.cache/mikoshi-alttabworkspace)
      N=$(echo "$prev" | cut -d: -f1)
      j=$(echo "$prev" | cut -d: -f2)
      msw "$N" "$j"
        '';
    };
    # active outputs ordered left to right, top to bottom; output j of desktop N is this list's j-th line
    mswOutputs = pkgs.writeShellScriptBin "msw-outputs" ''
      swaymsg -t get_outputs | jq -r '[.[] | select(.active)] | sort_by(.rect.x, .rect.y) | .[].name'
    '';
    mswMove = pkgs.writeShellScriptBin "msw-move" ''
      N=$1
      focused=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
      j=$(${mswOutputs}/bin/msw-outputs | grep -nxF "$focused" | cut -d: -f1)
      swaymsg "move container to workspace $N:$j"
    '';
    # nudge towards nwg-displays until a layout has been saved
    outputsHint = pkgs.writeShellScript "mikoshi-outputs-hint" ''
      [ -s "$HOME/.config/sway/outputs" ] ||
        ${pkgs.libnotify}/bin/notify-send "Monitors" "Press Alt+Shift+D to arrange your monitors"
    '';
    # `mikoshi-screenshot <grimshot target>`: save to ~/Pictures/Screenshots and copy
    screenshot = pkgs.writeShellApplication {
      name = "mikoshi-screenshot";
      runtimeInputs = [pkgs.sway-contrib.grimshot pkgs.libnotify];
      text = ''
        dir="$HOME/Pictures/Screenshots"
        mkdir -p "$dir"
        grimshot --notify savecopy "$1" "$dir/$(date +%Y-%m-%d_%H-%M-%S).png"
      '';
    };
    # awww caches images only per output it has seen and never caches `clear`,
    # so re-apply on every output event to cover hotplug
    wallpaper = pkgs.writeShellApplication {
      name = "mikoshi-wallpaper";
      runtimeInputs = [pkgs.awww config.programs.sway.package];
      text = ''
        apply() {
          ${
          if cfg.wallpaper == null
          then "awww clear ${lib.removePrefix "#" palette.base}"
          else "awww img \"${cfg.wallpaper}\""
        }
        }
        until awww query >/dev/null 2>&1; do sleep 0.2; done
        apply
        swaymsg -t subscribe -m '["output"]' | while read -r _; do
          sleep 1
          apply
        done
      '';
    };
    mikoshiWorkspaceSwitcher = pkgs.writeShellScriptBin "msw" ''
      N=$1
      focus_index=''${2:-}
      original=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
      monitors=$(${mswOutputs}/bin/msw-outputs)
      count=$(echo "$monitors" | wc -l)

      # Move orphaned windows
      swaymsg -t get_workspaces | jq -r --arg n "$N" '.[].name | select(startswith($n + ":"))' |
      while IFS= read -r ws; do
          j=''${ws#*:}
          if [ "$j" -gt "$count" ]; then
              swaymsg "[workspace=\"^$ws\$\"] move container to workspace $N:$count"
          fi
      done
      
      # Create workspace layout
      j=1
      focus_output=""
      while IFS= read -r monitor; do
          swaymsg "focus output $monitor; workspace $N:$j; move workspace to output $monitor"
          if [ "$j" = "$focus_index" ]; then
              focus_output=$monitor
          fi
          j=$((j + 1))
      done <<< "$monitors"

      if [ -n "$focus_output" ]; then
          swaymsg "focus output $focus_output"
      else
          swaymsg "focus output $original"
      fi
    '';
  in {
    options.mikoshi.wm.sway = {
      enable = lib.mkEnableOption "Sway desktop";
      wallpaper = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Wallpaper image. When null, every output is filled with the palette's base colour.";
      };
      directScanout = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Allow wlroots direct scanout of fullscreen windows. Off by default; enable if your GPU handles it without flicker.";
      };
    };
    config = lib.mkIf cfg.enable {
      mikoshi.walker.enable = lib.mkDefault true;
      mikoshi.waybar.enable = lib.mkDefault true;
      mikoshi.swaync.enable = lib.mkDefault true;
      mikoshi.lock.enable = lib.mkDefault true;
      mikoshi.regreet.enable = lib.mkDefault true;
      mikoshi.graphical.enable = lib.mkDefault true;
      mikoshi.appearance.enable = lib.mkDefault true;

      programs.sway = {
        enable = true;
        package = pkgs.swayfx;
        extraSessionCommands = lib.optionalString (!cfg.directScanout) ''
          export WLR_SCENE_DISABLE_DIRECT_SCANOUT=1
        '';
      };

      programs.uwsm = {
        enable = true;
        waylandCompositors.sway = {
          prettyName = "Sway";
          comment = "Sway compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/sway";
        };
      };

      environment.systemPackages = with pkgs; [
        jq
        swayidle
        playerctl
        mikoshiWorkspaceSwitcher
        mswMove
        mikoshiAltTab
        screenshot
        nwg-displays
      ];

      # sway's `include ~/.config/sway/outputs` needs the file to exist
      systemd.user.tmpfiles.rules = [
        "d %h/.config/sway 0755 - - -"
        "f %h/.config/sway/outputs 0644 - - -"
      ];

      # portals: programs.sway already enables the wlr (ScreenCast, Screenshot)
      # and gtk (everything else, incl. file chooser) portals and sets
      # xdg.portal.config.sway accordingly

      home-manager.users = hmFor config.mikoshi.meta.users {
        imports = [hmClass.sway];

        services.swayosd.enable = true;
        services.polkit-gnome.enable = true;

        systemd.user.services.mikoshiAltTabDaemon = {
          Unit = {
            Description = "Mikoshi alt-tab workspace tracker";
            After = ["graphical-session.target"];
            PartOf = ["graphical-session.target"];
          };
          Service = {
            ExecStart = "${altTabDaemon}/bin/mikoshiAltTabDaemon";
            Restart = "on-failure";
            RestartSec = "5s";
          };
          Install.WantedBy = ["graphical-session.target"];
        };

        services.awww.enable = true;

        systemd.user.services.mikoshiWallpaper = {
          Unit = {
            Description = "Mikoshi wallpaper setter";
            After = ["graphical-session.target" "awww.service"];
            Wants = ["awww.service"];
            # restarting the daemon drops a solid colour, so re-run with it
            PartOf = ["graphical-session.target" "awww.service"];
          };
          Service = {
            ExecStart = "${wallpaper}/bin/mikoshi-wallpaper";
            Restart = "on-failure";
            RestartSec = "5s";
          };
          Install.WantedBy = ["graphical-session.target"];
        };

        systemd.user.services.mikoshiOutputsHint = {
          Unit = {
            Description = "Mikoshi first-run monitor arrangement hint";
            After = ["graphical-session.target" "swaync.service"];
            PartOf = ["graphical-session.target"];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${outputsHint}";
          };
          Install.WantedBy = ["graphical-session.target"];
        };
      };
    };
    
  };

  flake.modules.homeManager.sway = {
    lib,
    osConfig,
    ...
  }: let
    palette = (import ./_palette.nix).${osConfig.mikoshi.theme.polarity};
    # $mod+N switches desktop N on every monitor, $mod+Shift+N sends the
    # focused window to desktop N on this monitor; 0 is desktop 10
    workspaceBinds = lib.concatMapStrings (n: let
      key = toString (lib.mod n 10);
    in ''
      bindsym $mod+${key} exec msw ${toString n}
      bindsym $mod+Shift+${key} exec msw-move ${toString n}
    '') (lib.genList (i: i + 1) 10);
  in {
    wayland.windowManager.sway = {
      enable = true;
      # swayfx comes from the NixOS module; null also skips the config check,
      # which can't see ~/.config/sway/outputs or swayfx-only commands
      package = null;
      # UWSM exports the environment and owns graphical-session.target
      systemd.enable = false;
      config = null;
      extraConfig = ''
        set $mod Mod1
        set $term ghostty

        # monitor layout, written by nwg-displays ($mod+Shift+d)
        include ~/.config/sway/outputs

        font pango:monospace 10
        seat * xcursor_theme WhiteSur-cursors 24
        input type:pointer {
            accel_profile flat
            pointer_accel 0
        }

        focus_follows_mouse yes
        mouse_warping output

        ${workspaceBinds}
        # focus
        bindsym $mod+h focus left
        bindsym $mod+j focus down
        bindsym $mod+k focus up
        bindsym $mod+l focus right
        bindsym $mod+Left focus left
        bindsym $mod+Down focus down
        bindsym $mod+Up focus up
        bindsym $mod+Right focus right

        # move windows
        bindsym $mod+Shift+h move left
        bindsym $mod+Shift+j move down
        bindsym $mod+Shift+k move up
        bindsym $mod+Shift+l move right
        bindsym $mod+Shift+Left move left
        bindsym $mod+Shift+Down move down
        bindsym $mod+Shift+Up move up
        bindsym $mod+Shift+Right move right

        bindsym --release Super_L exec walker

        # layout / floating
        bindsym $mod+s layout stacking
        bindsym $mod+w layout tabbed
        bindsym $mod+e layout toggle split
        bindsym $mod+Shift+space floating toggle
        bindsym $mod+space focus mode_toggle
        bindsym $mod+a focus parent

        # resize mode
        mode "resize" {
            bindsym h resize shrink width 10px
            bindsym j resize grow height 10px
            bindsym k resize shrink height 10px
            bindsym l resize grow width 10px
            bindsym Left resize shrink width 10px
            bindsym Down resize grow height 10px
            bindsym Up resize shrink height 10px
            bindsym Right resize grow width 10px

            bindsym Return mode "default"
            bindsym Escape mode "default"
        }
        bindsym $mod+r mode "resize"

        bindsym $mod+Return exec $term
        bindsym $mod+Shift+q kill
        bindsym $mod+f fullscreen
        bindsym $mod+Shift+c reload
        bindsym $mod+Shift+e exec swaymsg exit
        bindsym Mod4+l exec loginctl lock-session
        bindsym $mod+Shift+d exec nwg-displays
        bindsym $mod+Tab exec mikoshiAltTab

        # screenshots: save to ~/Pictures/Screenshots and copy
        bindsym $mod+Shift+s exec mikoshi-screenshot area
        bindsym Print exec mikoshi-screenshot output

        # volume / brightness (swayosd)
        bindsym XF86AudioRaiseVolume exec swayosd-client --output-volume raise
        bindsym XF86AudioLowerVolume exec swayosd-client --output-volume lower
        bindsym XF86AudioMute exec swayosd-client --output-volume mute-toggle
        bindsym XF86AudioMicMute exec swayosd-client --input-volume mute-toggle
        bindsym XF86MonBrightnessUp exec swayosd-client --brightness raise
        bindsym XF86MonBrightnessDown exec swayosd-client --brightness lower

        # media keys
        bindsym XF86AudioNext exec playerctl next
        bindsym XF86AudioPrev exec playerctl previous
        bindsym XF86AudioPlay exec playerctl play-pause
        bindsym XF86AudioPause exec playerctl play-pause

        gaps inner 8
        gaps outer 8
        default_border pixel 2
        corner_radius 16
        smart_corner_radius enable

        # class                 border           background       text           indicator        child_border
        client.focused          ${palette.accent} ${palette.accent} ${palette.text} ${palette.accent} ${palette.accent}
        client.focused_inactive ${palette.subtle} ${palette.surface} ${palette.text} ${palette.subtle} ${palette.subtle}
        client.unfocused        ${palette.subtle} ${palette.base} ${palette.muted} ${palette.subtle} ${palette.subtle}
        client.urgent           ${palette.danger} ${palette.danger} ${palette.base} ${palette.danger} ${palette.danger}

        layer_effects "waybar" blur enable; corner_radius 12
        layer_effects "swaync-control-center" blur enable; corner_radius 16
        layer_effects "swaync-notification-window" blur enable; corner_radius 16
        # walker is a full-screen transparent surface; blur only behind the box
        layer_effects "walker" blur enable; blur_ignore_transparent enable

        exec msw 1
        exec exec uwsm finalize
      '';
    };
  };
}
