{config, ...}: {
  flake.nixosModules.tmux = {
    imports = [./system.nix config.flake.nixosModules.home-manager];
  };
}
