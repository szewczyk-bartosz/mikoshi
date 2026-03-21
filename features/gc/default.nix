{...}: {
  flake.nixosModules.gc = import ./system.nix;
}
