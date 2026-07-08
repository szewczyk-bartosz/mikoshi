{...}: {
  flake.modules.nixos.base = {
    lib,
    config,
    ...
  }: {
    networking.networkmanager.enable = true;
  };
}
