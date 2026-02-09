{self, ...}: {
  flake.modules.nixos.hyprland = {
    config,
    lib,
    ...
  }: {
    imports = [self.modules.nixos.hyprlandOptions];
    config = lib.mkIf config.mikoshi.hyprland.enable {
      programs.hyprland.enable = true;
      home-manager.sharedModules = [self.modules.homeManager.hyprland];
    };
  };
}
