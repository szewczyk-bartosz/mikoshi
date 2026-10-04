{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
  gtkColors = config.flake.lib.gtkColors;
in {
  flake.modules.nixos.waybar = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.mikoshi.waybar;
  in {
    options.mikoshi.waybar = {
      enable = lib.mkEnableOption "waybar status bar";

      battery.enable = lib.mkEnableOption "waybar battery tray icon";
    };
    config = lib.mkIf cfg.enable {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.waybar;

      environment.systemPackages = [pkgs.pavucontrol];
    };
  };

flake.modules.homeManager.waybar = {
  lib,
  osConfig,
  ...
}: let
  palette = (import ./_palette.nix).${osConfig.mikoshi.theme.polarity};
in {
  config.programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      margin-top = 8;
      margin-left = 16;
      margin-right = 16;

      modules-left = ["sway/workspaces" "sway/window"];
      modules-center = ["clock"];
      modules-right =
        ["pulseaudio" "tray"]
        ++ lib.optionals osConfig.mikoshi.waybar.battery.enable ["battery"]
        ++ ["custom/power"];

      "sway/workspaces" = {
        format = "{icon}";
        format-icons = {
          focused = "●";
          default = "○";
        };
        disable-scroll = true;
      };

      "sway/window".max-length = 50;

      clock = {
        format = "{:%H:%M  %a %d %b}";
        on-click = "swaync-client -t";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟";
        on-click = "pavucontrol";
        format-icons.default = ["󰕿" "󰖀" "󰕾"];
      };

      battery = lib.mkIf osConfig.mikoshi.waybar.battery.enable {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}%";
      };

      tray.spacing = 8;

      "custom/power" = {
        format = "⏻";
        tooltip = false;
        on-click = "swaynag -t warning -m 'Power?' -B 'Shutdown' 'systemctl poweroff' -B 'Reboot' 'systemctl reboot' -B 'Logout' 'swaymsg exit'";
      };
    };

    style = gtkColors palette + ''
      * {
        font-family: sans-serif;
        font-size: 13px;
        border: none;
        border-radius: 0;
        padding: 0;
        margin: 0;
      }

      window#waybar {
        background: alpha(@base, 0.75);
        border: 1px solid alpha(@accent, 0.2);
        border-radius: 12px;
        color: @text;
      }

      #workspaces { padding: 0 6px; }
      #workspaces button {
        padding: 0 4px;
        color: @muted;
        background: transparent;
        min-width: 0;
      }
      #workspaces button.focused { color: @accent; }
      #workspaces button.urgent { color: @danger; }

      #window { padding: 0 8px; color: @muted; }

      #clock,
      #pulseaudio,
      #battery,
      #custom-power { padding: 0 12px; }

      #pulseaudio.muted,
      #custom-power { color: @muted; }
      #custom-power:hover { color: @text; }
      #battery.warning { color: @warning; }
      #battery.critical { color: @danger; }

      #tray { padding: 0 8px; }
    '';
  };
};
}
