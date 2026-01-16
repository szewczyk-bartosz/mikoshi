{lib, ...}: {
  flake.nixosModules.options = {
    lib,
    pkgs,
    ...
  }: {
    options.mikoshi = {
      hyprland = {
        enable = lib.mkEnableOption "Mikoshi's hyprland setup";
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

      terminal = {
        font = {
          package = lib.mkOption {
            default = pkgs.nerd-fonts.jetbrains-mono;
            type = lib.types.package;
            description = "font package to be used within the terminal";
          };
          size = lib.mkOption {
            default = 12;
            type = lib.types.int;
            description = "font size to use in terminal";
          };
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
