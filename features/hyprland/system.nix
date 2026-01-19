{self, ...}: {
  flake.modules.nixos.hyprland = {
    config,
    lib,
    ...
  }: {
    imports = [self.nixosModules.options];
    config = lib.mkIf config.mikoshi.hyprland.enable {
      programs.hyprland.enable = true;
      home-manager.sharedModules = [self.homeManagerModules.hyprland];
    };
  };
}
