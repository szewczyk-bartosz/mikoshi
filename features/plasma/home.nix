{
  osConfig,
  lib,
  ...
}: let
  mod = osConfig.mikoshi.plasma.mainMod;
in {
  xdg.configFile."kwinrc".text = lib.generators.toINI {} {
    Tiling = {
      enable = true;
    };
    "Tiling\\1" = {
      padding = 4;
    };
    Desktops = {
      Number = 4;
      Rows = 1;
    };
    Windows = {
      FocusPolicy = "FocusFollowsMouse";
    };
  };

  xdg.configFile."kglobalshortcutsrc".text = lib.generators.toINI {} {
    kwin = {
      "Switch Window Left" = "${mod}+H,none,Switch Window Left";
      "Switch Window Down" = "${mod}+J,none,Switch Window Down";
      "Switch Window Up" = "${mod}+K,none,Switch Window Up";
      "Switch Window Right" = "${mod}+L,none,Switch Window Right";

      "Move Window Left" = "Ctrl+${mod}+H,none,Move Window Left";
      "Move Window Down" = "Ctrl+${mod}+J,none,Move Window Down";
      "Move Window Up" = "Ctrl+${mod}+K,none,Move Window Up";
      "Move Window Right" = "Ctrl+${mod}+L,none,Move Window Right";

      "Switch to Desktop 1" = "${mod}+1,none,Switch to Desktop 1";
      "Switch to Desktop 2" = "${mod}+2,none,Switch to Desktop 2";
      "Switch to Desktop 3" = "${mod}+3,none,Switch to Desktop 3";
      "Switch to Desktop 4" = "${mod}+4,none,Switch to Desktop 4";
      "Switch to Desktop 5" = "${mod}+5,none,Switch to Desktop 5";
      "Switch to Desktop 6" = "${mod}+6,none,Switch to Desktop 6";
      "Switch to Desktop 7" = "${mod}+7,none,Switch to Desktop 7";
      "Switch to Desktop 8" = "${mod}+8,none,Switch to Desktop 8";
      "Switch to Desktop 9" = "${mod}+9,none,Switch to Desktop 9";

      "Window to Desktop 1" = "Shift+${mod}+1,none,Window to Desktop 1";
      "Window to Desktop 2" = "Shift+${mod}+2,none,Window to Desktop 2";
      "Window to Desktop 3" = "Shift+${mod}+3,none,Window to Desktop 3";
      "Window to Desktop 4" = "Shift+${mod}+4,none,Window to Desktop 4";
      "Window to Desktop 5" = "Shift+${mod}+5,none,Window to Desktop 5";
      "Window to Desktop 6" = "Shift+${mod}+6,none,Window to Desktop 6";
      "Window to Desktop 7" = "Shift+${mod}+7,none,Window to Desktop 7";
      "Window to Desktop 8" = "Shift+${mod}+8,none,Window to Desktop 8";
      "Window to Desktop 9" = "Shift+${mod}+9,none,Window to Desktop 9";
    };
  };
}
