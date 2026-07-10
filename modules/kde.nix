{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
  nixosClass = config.flake.modules.nixos;
in {
  flake.modules.nixos.plasma = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [nixosClass.graphical];
    config = {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.plasma;
    };
  };

  flake.modules.homeManager.plasma = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    config = {
    };
  };
}
