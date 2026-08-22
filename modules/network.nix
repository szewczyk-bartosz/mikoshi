{...}: {
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: let
    cfg = config.mikoshi.network;
  in {
    options.mikoshi.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable mikoshi's network config (network manager)";
      };
    };
    config = lib.mkIf cfg.enable {
      networking.networkmanager.enable = lib.mkDefault true;
    };
  };
}
