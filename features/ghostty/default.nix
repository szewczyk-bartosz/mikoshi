{...}: {
  flake.nixosModules.ghostty = {
    imports = [./system.nix];
  };
}
