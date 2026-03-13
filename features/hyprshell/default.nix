{config, ...}:
let
  homeManagerModule = config.flake.nixosModules.home-manager;
in {
  flake.nixosModules.hyprshell = {
    imports = [./system.nix homeManagerModule];
  };
}
