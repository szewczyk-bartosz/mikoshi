{...}: {
  flake.nixosModules.home-manager = import ./system.nix;
}
