{
  osConfig,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.mikoshi.hyprland.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
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
          font-size: 13px;
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
}
