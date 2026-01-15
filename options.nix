{lib, ...}: {
  flake.nixosModules.options = {lib, ...}: {
    options.mikoshi = {
      hyprland = {
        enable = lib.mkEnableOption "Mikoshi's hyprland setup";
        monitor = lib.mkOption {
          default = [",preferred,auto,auto"];
          type = lib.types.listOf lib.types.str;
          description = "A list of Hyprland monitor configurations (format: 'name,resolution,position,scale')";
        };

        keyboardLayout = lib.mkOption {
          default = "gb";
          type = lib.types.str;
          description = "Keyboard layout to use";
        };
      };

      theme = lib.mkOption {
        default = "akasara";
        type = lib.types.str;
        description = "the theme that Mikoshi will use currently not implemented"; # TODO: Implement themes
      };
    };
  };
}
