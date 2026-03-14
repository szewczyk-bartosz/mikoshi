{config, ...}: {
  flake.nixosModules.waybar = {
    imports = [./system.nix config.flake.nixosModules.home-manager];
  };
}
