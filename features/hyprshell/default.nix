{self, ...}: {
  flake.modules.nixos.hyprshell = {
    config,
    lib,
    ...
  }: {
    imports = [./options.nix];
    config = lib.mkIf config.mikoshi.hyprshell.enable {
      home-manager.sharedModules = [self.modules.homeManager.hyprshell];
    };
  };
  imports = [
    ./home.nix
  ];
}
