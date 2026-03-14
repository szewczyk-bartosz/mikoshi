{lib, ...}: {
  options.mikoshi.hyprland = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable Mikoshi's hyprland setup";
    };
    monitors = lib.mkOption {
      default = [",preferred,auto,auto"];
      type = lib.types.listOf lib.types.str;
      description = "A list of Hyprland monitor configurations (format: 'name,resolution,position,scale')";
    };

    keyboardLayout = lib.mkOption {
      default = "gb";
      type = lib.types.str;
      description = "Keyboard layout to use";
    };

    mainMod = lib.mkOption {
      default = "ALT";
      type = lib.types.str;
      description = "the button to use as mainMod";
    };
  };
}
