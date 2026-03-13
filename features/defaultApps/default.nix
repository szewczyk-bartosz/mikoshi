{...}: {
  flake.nixosModules.defaultApps = import ./system.nix;
}
