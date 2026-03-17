{...}: {
  flake.nixosModules.gnome = {
    imports = [./system.nix];
  };
}
