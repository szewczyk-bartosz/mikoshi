{inputs, ...}: {
  flake.modules.nixos.neovim = {
    imports = [inputs.mikoshi-neovim.nixosModules.default];
  };
}
