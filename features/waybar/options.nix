{...}: {
  flake.modules.nixos.waybarOptions = {
    lib,
    pkgs,
    ...
  }: {
    options.mikoshi.waybar = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable waybar";
      };
    };
  };
}
