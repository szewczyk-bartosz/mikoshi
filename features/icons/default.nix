{...}: {
  flake.nixosModules.icons = {
    imports = [./system.nix];
  };
}
