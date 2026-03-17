{
  osConfig,
  lib,
  ...
}: {
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "pop-shell@system76.com"
      ];
    };
    # Dark mode and normal scaling
    "org/gnome/desktop/interface" = {
      color-scheme = lib.mkDefault "prefer-dark";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [(lib.hm.gvariant.mkTuple ["xkb" "${osConfig.mikoshi.gnome.kb}"])];
    };
    "org/gnome/shell/extensions/pop-shell" = {
      show-title = false; # Disable launcher

      gap-inner = 4;
      gap-outer = 4;

      tile-by-default = true;
      active-hint = true;
      smart-gaps = true; # No gaps if only one window

      float-window-classes = [
        "nm-applet"
        "gnome-calculator"
        "steam_app_0"
        "steam_app_1"
      ];

      focus-left = ["<Alt>h"];
      focus-down = ["<Alt>j"];
      focus-up = ["<Alt>k"];
      focus-right = ["<Alt>l"];

      tile-move-left = ["<Control><Alt>h"];
      tile-move-down = ["<Control><Alt>j"];
      tile-move-up = ["<Control><Alt>k"];
      tile-move-right = ["<Control><Alt>l"];
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = ["<Alt>1"];
      switch-to-workspace-2 = ["<Alt>2"];
      switch-to-workspace-3 = ["<Alt>3"];
      switch-to-workspace-4 = ["<Alt>4"];
      switch-to-workspace-5 = ["<Alt>5"];
      switch-to-workspace-6 = ["<Alt>6"];
      switch-to-workspace-7 = ["<Alt>7"];
      switch-to-workspace-8 = ["<Alt>8"];
      switch-to-workspace-9 = ["<Alt>9"];

      move-to-workspace-1 = ["<Alt><Shift>1"];
      move-to-workspace-2 = ["<Alt><Shift>2"];
      move-to-workspace-3 = ["<Alt><Shift>3"];
      move-to-workspace-4 = ["<Alt><Shift>4"];
      move-to-workspace-5 = ["<Alt><Shift>5"];
      move-to-workspace-6 = ["<Alt><Shift>6"];
      move-to-workspace-7 = ["<Alt><Shift>7"];
      move-to-workspace-8 = ["<Alt><Shift>8"];
      move-to-workspace-9 = ["<Alt><Shift>9"];
    };
  };
}
