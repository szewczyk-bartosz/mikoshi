{...}: {
  flake.nixosModules.tmux = {
    imports = [./system.nix];
  };
}
