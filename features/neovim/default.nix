{inputs, ...}: {
  flake.nixosModules.neovim = {
    imports = [inputs.nvf.nixosModules.default ./system.nix];
  };
}
