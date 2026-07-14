{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
  nixosClass = config.flake.modules.nixos;
in {
  flake.modules.nixos.hyprland = {
    config,
    pkgs,
    lib,
    ...
  }: let
    daemon = pkgs.writers.writePython3Bin "hyprland-alt-tab-daemon" {} ''
      import socket
      import os
      import sys


      def get_socket_path():
          sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
          if not sig:
              sys.exit(1)
          runtime_dir = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
          return f"{runtime_dir}/hypr/{sig}/.socket2.sock"


      def main():
          state_file = os.path.expanduser("~/.cache/hypr-altworkspace")
          sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
          sock.connect(get_socket_path())
          current = "1"
          with open(state_file, "w") as f:
              f.write("1")
          buf = ""
          while True:
              buf += sock.recv(4096).decode("utf-8", errors="ignore")
              while "\n" in buf:
                  line, buf = buf.split("\n", 1)
                  if line.startswith("workspace>>"):
                      new = line.split(">>")[1].strip()
                      if new != current:
                          with open(state_file, "w") as f:
                              f.write(current)
                          current = new


      main()
    '';
    switcher = pkgs.writeShellScriptBin "hyprland-alt-tab" ''
      prev=$(cat ~/.cache/hypr-altworkspace 2>/dev/null || echo "1")
      hyprctl dispatch workspace "$prev"
    '';
  in {
    config = {
      programs.hyprland.enable = true;
      programs.hyprland.withUWSM = true;
      home-manager = {
        sharedModules = [./home.nix ./waybar.nix];
      };
      # Not sure how I feel about this, this might be lighter but I think I prefer the look of the gnome one
      # services.greetd = {
      #   enable = true;
      #   settings = {
      #     default_session = {
      #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
      #       user = "greeter";
      #     };
      #   };
      # };

      systemd.user.services.hyprpaper = lib.mkIf (config.mikoshi.hyprland.wallpaper != null) {
        description = "Hyprland wallpaper service";
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        bindsTo = ["graphical-session.target"];
        serviceConfig.ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      };

      systemd.user.services.swayosd-server = {
        description = "SwayOSD Server";
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        serviceConfig.ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
      };
      console = {
        font = lib.mkDefault "Lat2-Terminus16";
        useXkbConfig = lib.mkDefault true;
      };

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
            user = "greeter";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        daemon
        switcher
        wofi
        playerctl
        pavucontrol
        wlogout
        brightnessctl
        waybar
        swaynotificationcenter
        networkmanagerapplet
        lxqt.lxqt-policykit
        grimblast
        nautilus
        swayosd
      ];

      xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-hyprland];
        config.common.default = "*";
      };
    };
  };

  flake.modules.homeManager.hyprland = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    config = {
      xdg.configFile."hypr/hyprpaper.conf" = lib.mkIf (osConfig.mikoshi.hyprland.wallpaper != null) {
        text = ''
          wallpaper {
            monitor =
            path = ${osConfig.mikoshi.hyprland.wallpaper}
            fit_mode = cover
          }
        '';
      };
      wayland.windowManager.hyprland = {
        enable = true;
        configType = "hyprlang";
        settings = {
          "$mainMod" = osConfig.mikoshi.hyprland.mainMod;
          "$terminal" = lib.getExe osConfig.mikoshi.hyprland.terminal;
          "$fileManager" = lib.getExe osConfig.mikoshi.hyprland.fileManager;

          monitor = osConfig.mikoshi.hyprland.monitors;

          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
            "XCURSOR_THEME,Adwaita"
            "NIXOS_OZONE_WL,1"
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"
          ];

          "exec-once" = [
            "lxqt-polkit"
            "waybar"
            "swaync"
            "sleep 2; nm-applet --indicator"
            "hyprland-alt-tab-daemon"
            "systemctl --user start graphical-session.target"
          ];

          input = {
            kb_layout = osConfig.mikoshi.hyprland.kb;
            kb_options = osConfig.mikoshi.hyprland.kbOptions;
            follow_mouse = 1;
            sensitivity = 0;
            accel_profile = "flat";
            touchpad = {
              natural_scroll = false;
            };
          };

          general = {
            gaps_in = 5;
            gaps_out = "50,20,20,20";
            border_size = 2;
            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";
          };

          render = {
            direct_scanout = 0;
          };

          decoration = lib.mkDefault {
            rounding = 10;
            rounding_power = 2;
            active_opacity = 1.0;
            inactive_opacity = 1.0;
            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };
            blur = {
              enabled = false;
              # size = 3;
              # passes = 1;
              # vibrancy = 0.1696;
            };
          };

          animations = {
            enabled = true;
            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1.0"
              "quick,0.15,0,0.1,1"
            ];
            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 0, 1.94, almostLinear, fade"
              "workspacesIn, 0, 1.21, almostLinear, fade"
              "workspacesOut, 0, 1.94, almostLinear, fade"
            ];
          };

          dwindle = {
            preserve_split = true;
          };

          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
          };

          bind = [
            # core
            "$mainMod, RETURN, exec, $terminal"
            "$mainMod SHIFT, Q, killactive"
            "$mainMod SHIFT, O, exit"
            # "$mainMod, E, exec, $fileManager"
            "$mainMod, V, togglefloating"
            "${osConfig.mikoshi.hyprland.launcherKeybind}, exec, pkill wofi || wofi --show drun"
            # focus
            "$mainMod, H, movefocus, l"
            "$mainMod, J, movefocus, d"
            "$mainMod, K, movefocus, u"
            "$mainMod, L, movefocus, r"
            # move window
            "$mainMod SHIFT, H, movewindow, l"
            "$mainMod SHIFT, J, movewindow, d"
            "$mainMod SHIFT, K, movewindow, u"
            "$mainMod SHIFT, L, movewindow, r"
            # workspaces
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"
            "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
            "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
            "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
            "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
            "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
            "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
            "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
            "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
            "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
            "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

            # screenshot
            "$mainMod SHIFT, S, exec, grimblast copysave area ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"

            # Alt tab maybe?
            "ALT, Tab, exec, hyprland-alt-tab"
          ];

          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];

          # bindel = [
          #   ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          #   ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          #   ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          #   ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          #   ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
          #   ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
          # ];
          bindel = [
            ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
            ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
            ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
            ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
            ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
            ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
          ];
          bindl = [
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPause, exec, playerctl play-pause"
          ];
        };
      };

      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            exclusive = false;
            height = 30;

            modules-left = ["hyprland/workspaces"];
            modules-center = ["clock"];
            modules-right = ["tray" "pulseaudio" "custom/power"];

            "hyprland/workspaces" = {
              format = "{id}";
              on-click = "activate";
              persistent-workspaces = {
                "*" = 4;
              };
            };

            clock = {
              format = "{:%H:%M  %a %d %b}";
              on-click = "swaync-client -t";
            };

            "tray" = {
              spacing = 8;
            };

            pulseaudio = {
              format = "{icon} {volume}%";
              format-muted = "󰝟 Muted";
              on-click = "pavucontrol";
              format-icons = {
                default = ["󰕿" "󰖀" "󰕾"];
              };
            };

            "custom/power" = {
              format = "⏻";
              on-click = "wlogout";
              tooltip = false;
            };
          };
        };

        style = ''
          * {
            font-family: monospace;
            font-size: 16px;
            border: none;
            border-radius: 0;
            padding: 0;
            margin: 0;
          }

          window#waybar {
            padding: 0 8px;
          }

          #workspaces button {
            padding: 0 8px;
          }

          #workspaces button.active {
            font-weight: bold;
          }

          #clock,
          #network,
          #pulseaudio,
          #custom-power {
            padding: 0 12px;
          }
        '';
      };
    };
  };
}
