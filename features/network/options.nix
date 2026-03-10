{...}: {
  flake.modules.nixos.networkOptions = {
    lib,
    ...
  }: {
    options.mikoshi.network = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable Mikoshi's network setup";
      };
    };
  };
}
