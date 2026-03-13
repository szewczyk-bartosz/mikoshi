{lib, ...}: {
  options.mikoshi.gnome = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable Mikoshi's gnome setup";
    };
    kb = lib.mkOption {
      default = "gb";
      type = lib.types.str;
      description = "the keyboard layout to set";
    };
  };
}
