{...}: {
  flake.nixosModules.hyprland = {
    imports = [./system.nix];
  };
}
