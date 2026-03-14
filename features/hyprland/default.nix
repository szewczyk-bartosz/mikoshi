{config, ...}: {
  flake.nixosModules.hyprland = {
    imports = [./system.nix config.flake.nixosModules.home-manager];
  };
}
