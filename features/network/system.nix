{self, ...}: {
  flake.modules.nixos.network = {
    config,
    lib,
    ...
  }: {
    imports = [self.modules.nixos.networkOptions];
    config = lib.mkIf config.mikoshi.network.enable {
      networking.networkmanager.enable = true;
    };
  };
}
