{self, ...}: {
  flake.modules.nixos.tmux = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      self.modules.nixos.tmuxOptions
      self.modules.nixos.homeManager
    ];
    config = lib.mkIf config.mikoshi.tmux.enable {
      home-manager.sharedModules = [self.modules.homeManager.tmux];
    };
  };
}
