{self, ...}: {
  flake.nixosModules.default = {
    config,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.options
      self.nixosModules.hyprland
    ];

    home-manager.sharedModules = [self.homeManagerModules.hyprland];
  };
}
