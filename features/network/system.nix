{
  config,
  lib,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.network.enable {
    networking.networkmanager.enable = true;
  };
}
