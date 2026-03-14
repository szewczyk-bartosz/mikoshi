{
  osConfig,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.mikoshi.hyprland.enable {
    home.packages = with pkgs; [
      swaynotificationcenter
      wlogout
      networkmanagerapplet
      pavucontrol
      playerctl
      brightnessctl
    ];

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;

          modules-left = ["hyprland/workspaces"];
          modules-center = ["clock"];
          modules-right = ["network" "pulseaudio" "custom/power"];

          "hyprland/workspaces" = {
            format = "{id}";
            on-click = "activate";
          };

          clock = {
            format = "%H:%M  %a %d %b";
            on-click = "swaync-client -t";
          };

          network = {
            format-wifi = "{icon} {essid}";
            format-ethernet = "󰈀 Wired";
            format-disconnected = "󰖪 Disconnected";
            on-click = "nm-applet";
            format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
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
            format = "";
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
