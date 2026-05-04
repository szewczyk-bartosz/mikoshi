{lib, ...}: {
  options.mikoshi.gnome = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable Mikoshi's gnome setup";
    };
    kb = lib.mkOption {
      default = ["gb"];
      type = lib.types.listOf lib.types.str;
      description = "the keyboard layouts to set";
    };
    mainMod = lib.mkOption {
      default = "Alt";
      type = lib.types.str;
      description = "Modifier key to use for keybindings (GSettings format, e.g. Alt, Super, Control)";
    };
  };
}
