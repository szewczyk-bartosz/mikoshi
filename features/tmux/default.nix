{...}: {
  flake.nixosModules.tmux = import ./system.nix;
}
