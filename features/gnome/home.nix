{...}: {
  flake.modules.homeManager.gnome = {
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

      "org/gnome/desktop/inputs-sources" = {
        xkb-options = ["ctrl:nocaps"];
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
        ];

        focus-left = ["<Alt>h"];
        focus-down = ["<Alt>j"];
        focus-up = ["<Alt>k"];
        focus-right = ["<Alt>l"];

        tile-move-left = ["<Shift><Alt>h"];
        tile-move-down = ["<Shift><Alt>j"];
        tile-move-up = ["<Shift><Alt>k"];
        tile-move-right = ["<Shift><Alt>l"];

        tile-move-to-workspace-1 = ["<Shift><Alt>1"];
        tile-move-to-workspace-2 = ["<Shift><Alt>2"];
        tile-move-to-workspace-3 = ["<Shift><Alt>3"];
        tile-move-to-workspace-4 = ["<Shift><Alt>4"];
        tile-move-to-workspace-5 = ["<Shift><Alt>5"];
        tile-move-to-workspace-6 = ["<Shift><Alt>6"];
        tile-move-to-workspace-7 = ["<Shift><Alt>7"];
        tile-move-to-workspace-8 = ["<Shift><Alt>8"];
        tile-move-to-workspace-9 = ["<Shift><Alt>9"];
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
      };
    };
  };
}
