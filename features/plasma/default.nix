{...}: {
  flake.nixosModules.plasma = {
    imports = [./system.nix];
  };
}
