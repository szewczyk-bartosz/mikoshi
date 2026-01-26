{...}: {
  flake.modules.nixos.globalOptions = {
    lib,
    pkgs,
    ...
  }: {
    options.mikoshi = {
      mainMod = lib.mkOption {
        default = "ALT";
        type = lib.types.str;
        description = "the button to use as mainMod";
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
