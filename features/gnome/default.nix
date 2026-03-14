{config, ...}: {
  flake.nixosModules.gnome = {
    imports = [./system.nix config.flake.nixosModules.home-manager];
  };
}
