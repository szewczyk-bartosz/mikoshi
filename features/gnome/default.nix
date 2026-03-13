{config, ...}:
let
  homeManagerModule = config.flake.nixosModules.home-manager;
in {
  flake.nixosModules.gnome = {
    imports = [./system.nix homeManagerModule];
  };
}
