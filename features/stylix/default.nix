{inputs, ...}: {
  flake.nixosModules.stylix = {
    imports = [./system.nix inputs.stylix.nixosModules.default];
  };
}
