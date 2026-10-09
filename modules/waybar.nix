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

      minDesktops = lib.mkOption {
        type = lib.types.ints.between 1 10;
        default = 4;
        description = "Minimum number of desktops always shown in the bar.";
      };
    };
    config = lib.mkIf cfg.enable {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.waybar;

      environment.systemPackages = [pkgs.pavucontrol];
    };
  };

flake.modules.homeManager.waybar = {
  lib,
  pkgs,
  osConfig,
  ...
}: let
  palette = (import ./_palette.nix).${osConfig.mikoshi.theme.polarity};
  # sway drops empty hidden workspaces, so sway/workspaces differs per monitor;
  # derive desktops from workspace names instead so every bar looks the same
  desktops = pkgs.writeShellApplication {
    name = "mikoshi-desktops";
    runtimeInputs = [osConfig.programs.sway.package pkgs.jq];
    text = ''
      render() {
        swaymsg -t get_workspaces | jq -c \
          --arg accent "${palette.accent}" \
          --arg danger "${palette.danger}" \
          --arg muted "${palette.muted}" \
          --arg out "''${WAYBAR_OUTPUT_NAME:-}" \
          --argjson min ${toString osConfig.mikoshi.waybar.minDesktops} '
          map(select(.name | test("^[0-9]+:")) | .n = (.name | split(":")[0] | tonumber)) as $ws
          # only the bar on the focused output marks the current desktop
          | ($ws | map(select(.focused and .output == $out) | .n) | first) as $cur
          | ($ws | map(select(.urgent) | .n)) as $urgent
          | ($ws | map(select(.focus | length > 0) | .n)) as $occupied
          # length uses the global current desktop so every bar draws the same row
          | ([$min] + $occupied + ($ws | map(select(.focused) | .n)) | max) as $last
          | {text: ([range(1; $last + 1)] | map(
              . as $n
              | if $n == $cur then "<span color=\"\($accent)\">●</span>"
                elif ($urgent | index($n)) != null then "<span color=\"\($danger)\">○</span>"
                else "<span color=\"\($muted)\">○</span>"
                end
            ) | join(" "))}
        '
      }
      render
      swaymsg -t subscribe -m '["workspace"]' | while read -r _; do
        render
      done
    '';
  };
in {
  config.programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 38;
      margin-top = 8;
      margin-left = 16;
      margin-right = 16;

      modules-left = ["custom/desktops" "sway/window"];
      modules-center = ["clock"];
      modules-right =
        ["pulseaudio" "tray"]
        ++ lib.optionals osConfig.mikoshi.waybar.battery.enable ["battery"]
        ++ ["custom/power"];

      "custom/desktops" = {
        exec = lib.getExe desktops;
        return-type = "json";
        restart-interval = 1;
        tooltip = false;
      };

      "sway/window".max-length = 50;

      clock = {
        format = "{:%H:%M  %a %d %b}";
        on-click = "swaync-client -t -sw";
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
        on-click = "swaynag -t warning -m 'Currently not implemented'";
      };
    };

    style = gtkColors palette + ''
      * {
        font-family: "Nunito", sans-serif;
        font-size: 18px;
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

      #custom-desktops { padding: 0 10px; }

      #window { padding: 0 8px; color: @muted; }

      #clock,
      #pulseaudio,
      #battery,
      #custom-power { padding: 0 12px; }

      #custom-power {margin: 0 12px 0 0}

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
