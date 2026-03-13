{...}: {
  flake.nixosModules.gnome = import ./system.nix;
}
