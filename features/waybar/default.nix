{config, ...}: let
  homeManagerModule = config.flake.nixosModules.home-manager;
in {
  flake.nixosModules.waybar = {
    imports = [./system.nix homeManagerModule];
  };
}
