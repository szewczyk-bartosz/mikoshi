{config, ...}: {
  flake.modules.nixos.graphical = {lib, ...}: {
    imports = [config.flake.modules.nixos.base];
  };
}
