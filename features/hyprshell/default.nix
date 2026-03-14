{config, ...}: {
  flake.nixosModules.hyprshell = {
    imports = [./system.nix config.flake.nixosModules.home-manager];
  };
}
