{...}: {
  flake.modules.nixos.iconsOptions = {
    lib,
    ...
  }: {
    options.mikoshi.icons = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable icon and GTK theming";
      };
    };
  };
}
