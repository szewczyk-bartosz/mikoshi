{config, ...}: {
  flake.nixosModules.ghostty = {
    imports = [./system.nix config.flake.nixosModules.home-manager];
  };
}
