{config, ...}: {
  flake.nixosModules.icons = {
    imports = [./system.nix config.flake.nixosModules.home-manager];
  };
}
