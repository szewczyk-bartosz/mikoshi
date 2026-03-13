{...}: {
  flake.nixosModules.globalOptions = import ./options.nix;
}
