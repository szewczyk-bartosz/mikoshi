{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
  gtkColors = config.flake.lib.gtkColors;
in {
  flake.modules.nixos.swaync = {
    config,
    lib,
    ...
  }: {
    options.mikoshi.swaync.enable = lib.mkEnableOption "swaync notification centre";

    config = lib.mkIf config.mikoshi.swaync.enable {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.swaync;
    };
  };

  flake.modules.homeManager.swaync = {
    pkgs,
    osConfig,
    ...
  }: let
    palette = (import ./_palette.nix).${osConfig.mikoshi.theme.polarity};
  in {
    home.packages = [pkgs.libnotify];

    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        # bar is 32px tall with an 8px top margin
        control-center-margin-top = 48;
        control-center-margin-right = 16;
        control-center-margin-bottom = 16;
        notification-window-width = 400;
        control-center-width = 400;

        widgets = ["title" "dnd" "volume" "backlight" "notifications" "buttons-grid"];
        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = "Clear";
          };
          dnd.text = "Do not disturb";
          volume.label = "󰕾";
          backlight.label = "󰃠";
          buttons-grid.actions = [
            {
              label = "⏻";
              command = "systemctl poweroff";
            }
            {
              label = "";
              command = "systemctl reboot";
            }
            {
              label = "󰍃";
              command = "swaymsg exit";
            }
          ];
        };
      };

      style = gtkColors palette + ''
        * {
          font-family: sans-serif;
          font-size: 13px;
        }

        .notification-row { outline: none; }
        .notification-row .notification-background { padding: 4px 8px; }

        .notification-row .notification-background .notification,
        .control-center {
          background: alpha(@base, 0.8);
          border: 1px solid alpha(@text, 0.08);
          border-radius: 16px;
          color: @text;
        }

        .control-center { margin-bottom: 16px; }
        .control-center .notification-row .notification-background .notification {
          background: alpha(@surface, 0.6);
        }

        .notification.critical { border-color: @danger; }
        .summary { font-weight: bold; color: @text; }
        .body,
        .time { color: @muted; }

        .close-button {
          background: alpha(@surface, 0.8);
          color: @text;
          border-radius: 100%;
        }

        .notification-action,
        .widget-buttons-grid > flowbox > flowboxchild > button,
        .widget-title > button {
          background: alpha(@surface, 0.6);
          color: @text;
          border: none;
          border-radius: 12px;
        }

        .notification-action:hover,
        .widget-buttons-grid > flowbox > flowboxchild > button:hover,
        .widget-title > button:hover { background: @surface; }

        .widget-title,
        .widget-dnd,
        .widget-volume,
        .widget-backlight,
        .widget-buttons-grid {
          margin: 8px 16px;
          color: @text;
        }

        .widget-title > label { font-size: 16px; font-weight: bold; }

        .widget-dnd > switch {
          background: alpha(@surface, 0.8);
          border-radius: 12px;
        }
        .widget-dnd > switch:checked { background: @accent; }
        .widget-dnd > switch slider {
          background: @text;
          border-radius: 12px;
        }

        .widget-volume trough,
        .widget-backlight trough { background: alpha(@surface, 0.8); }
        .widget-volume highlight,
        .widget-backlight highlight { background: @muted; }
      '';
    };
  };
}
