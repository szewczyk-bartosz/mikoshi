{...}: {
  flake.nixosModules.audio = import ./system.nix;
}
