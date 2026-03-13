{...}: {
  flake.nixosModules.network = import ./system.nix;
}
