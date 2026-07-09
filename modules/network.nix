{...}: {
  flake.modules.nixos.base = {
    lib,
    config,
    ...
  }: {
    networking.networkmanager.enable = lib.mkDefault true;
  };
}
