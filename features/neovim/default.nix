{inputs, ...}: {
  flake.nixosModules.neovim = {
    imports = [inputs.mikoshi-neovim.nixosModules.default];
  };
}
