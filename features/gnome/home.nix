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
      sources = map (layout: lib.hm.gvariant.mkTuple ["xkb" layout]) osConfig.mikoshi.gnome.kb;
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

      focus-left = ["<${osConfig.mikoshi.gnome.mainMod}>h"];
      focus-down = ["<${osConfig.mikoshi.gnome.mainMod}>j"];
      focus-up = ["<${osConfig.mikoshi.gnome.mainMod}>k"];
      focus-right = ["<${osConfig.mikoshi.gnome.mainMod}>l"];

      tile-move-left = ["<Control><${osConfig.mikoshi.gnome.mainMod}>h"];
      tile-move-down = ["<Control><${osConfig.mikoshi.gnome.mainMod}>j"];
      tile-move-up = ["<Control><${osConfig.mikoshi.gnome.mainMod}>k"];
      tile-move-right = ["<Control><${osConfig.mikoshi.gnome.mainMod}>l"];
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = ["<${osConfig.mikoshi.gnome.mainMod}>1"];
      switch-to-workspace-2 = ["<${osConfig.mikoshi.gnome.mainMod}>2"];
      switch-to-workspace-3 = ["<${osConfig.mikoshi.gnome.mainMod}>3"];
      switch-to-workspace-4 = ["<${osConfig.mikoshi.gnome.mainMod}>4"];
      switch-to-workspace-5 = ["<${osConfig.mikoshi.gnome.mainMod}>5"];
      switch-to-workspace-6 = ["<${osConfig.mikoshi.gnome.mainMod}>6"];
      switch-to-workspace-7 = ["<${osConfig.mikoshi.gnome.mainMod}>7"];
      switch-to-workspace-8 = ["<${osConfig.mikoshi.gnome.mainMod}>8"];
      switch-to-workspace-9 = ["<${osConfig.mikoshi.gnome.mainMod}>9"];

      move-to-workspace-1 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>1"];
      move-to-workspace-2 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>2"];
      move-to-workspace-3 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>3"];
      move-to-workspace-4 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>4"];
      move-to-workspace-5 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>5"];
      move-to-workspace-6 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>6"];
      move-to-workspace-7 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>7"];
      move-to-workspace-8 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>8"];
      move-to-workspace-9 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>9"];
    };
  };
}
