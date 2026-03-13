{...}: {
  flake.nixosModules.neovim = import ./system.nix;
}
