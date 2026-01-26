{self, ...}: {
  flake.modules.nixos.hyprshell = {
    config,
    lib,
    ...
  }: {
    imports = [./options.nix self.modules.options];
    config = lib.mkIf config.mikoshi.hyprshell.enable {
      home-manager.sharedModules = [self.modules.homeManager.hyprshell];
    };
  };
}
