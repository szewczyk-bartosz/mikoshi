{config, ...}:
let
  homeManagerModule = config.flake.nixosModules.home-manager;
in {
  flake.nixosModules.hyprland = {
    imports = [./system.nix homeManagerModule];
  };
}
