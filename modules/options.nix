{...}: {
  flake.modules.nixos.base = {lib, ...}: {
    options.mikoshi = {
      meta = {
        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "Users to configure via home-manager on this host";
        };
        keyboardLayouts = lib.mkOption {
          default = ["gb"];
          type = lib.types.listOf lib.types.str;
          description = "the keyboard layouts to set";
        };
      };
      gnome = {
        mainMod = lib.mkOption {
          default = "Alt";
          type = lib.types.str;
          description = "Modifier key to use for keybindings (GSettings format, e.g. Alt, Super, Control)";
        };
      };

      plasma = {
        mainMod = lib.mkOption {
          default = "Alt";
          type = lib.types.str;
          description = "Modifier key to use for keybindings (GSettings format, e.g. Alt, Super, Control)";
        };
      };
    };
  };
}
