{
  config,
  inputs,
  ...
}: let
  homeManagerModule = config.flake.nixosModules.home-manager;
in {
  flake.nixosModules.stylix = {
    imports = [./system.nix homeManagerModule inputs.stylix.nixosModules.default];
  };
}
