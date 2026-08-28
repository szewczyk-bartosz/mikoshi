{ config, ... }:
let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.waybar =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.mikoshi.waybar;
    in
    {
      options.mikoshi.waybar = {
        enable = lib.mkEnableOption "waybar status bar";

        battery.enable = lib.mkEnableOption "waybar battery tray icon";
      };
      config = lib.mkIf cfg.enable {
        home-manager.users = hmFor config.mikoshi.meta.users hmClass.waybar;

        environment.systemPackages = with pkgs; [
          waybar
        ];

        systemd.user.services.waybar = {
          description = "Waybar";
          after = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];
          bindsTo = [ "graphical-session.target" ];
          serviceConfig.ExecStart = "${pkgs.waybar}/bin/waybar";
        };
      };
    };

  flake.modules.homeManager.waybar =
    {
      lib,
      osConfig,
      ...
    }:
    {
      config = {
        programs.waybar = {
          enable = true;
          settings = {
            mainBar = {
              layer = "top";
              position = "top";
              exclusive = false;
              height = 30;

              # TODO: will need to change this to make waybar WM agnostic
              modules-left = [ "hyprland/workspaces" ];
              modules-center = [ "clock" ];
              modules-right = [
                "tray"
                "pulseaudio"
                "custom/power"
              ]
              ++ lib.optionals osConfig.mikoshi.waybar.battery.enable [ "battery" ];

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

              battery = lib.mkIf osConfig.mikoshi.waybar.battery.enable {
                states = {
                  warning = 30;
                  critical = 15;
                };
                format = "{capacity}% {icon}";
                format-charging = "{capacity}% ⚡";
                format-plugged = "{capacity}% ";
                format-alt = "{time} {icon}";
                format-icons = [
                  ""
                  ""
                  ""
                  ""
                  ""
                ];
              };


              "tray" = {
                spacing = 8;
              };

              pulseaudio = {
                format = "{icon} {volume}%";
                format-muted = "󰝟 Muted";
                on-click = "pavucontrol";
                format-icons = {
                  default = [
                    "󰕿"
                    "󰖀"
                    "󰕾"
                  ];
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
            #battery,
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
