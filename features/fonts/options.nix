{...}: {
  flake.modules.nixos.fontsOptions = {
    lib,
    ...
  }: {
    options.mikoshi.fonts = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable fonts, sets sane defaults for system-wide font rendering";
      };
    };
  };
}
