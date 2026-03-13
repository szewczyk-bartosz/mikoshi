{config, ...}: let
  homeManagerModule = config.flake.nixosModules.home-manager;
in {
  flake.nixosModules.tmux = {
    imports = [./system.nix homeManagerModule];
  };
}
