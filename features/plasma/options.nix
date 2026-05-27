{lib, ...}: {
  options.mikoshi.plasma = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable mikoshi plasma";
    };
    kb = lib.mkOption {
      default = ["gb"];
      type = lib.types.listOf lib.types.str;
      description = "the keyboard layouts to set";
    };
    mainMod = lib.mkOption {
      default = "Alt";
      type = lib.types.str;
      description = "Modifier key to use for keybindings (KWin format, e.g. Alt, Meta, Ctrl)";
    };
  };
}
