{self, ...}: {
  flake.modules.nixos.hyprshell = {
    config,
    lib,
    ...
  }: {
    imports = [self.modules.nixos.hyprshellOptions];
    config = lib.mkIf config.mikoshi.hyprshell.enable {
      home-manager.sharedModules = [self.modules.homeManager.hyprshell];
    };
  };
}
