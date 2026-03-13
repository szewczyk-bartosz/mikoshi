{config, ...}:
let
  homeManagerModule = config.flake.nixosModules.home-manager;
in {
  flake.nixosModules.icons = {
    imports = [./system.nix homeManagerModule];
  };
}
