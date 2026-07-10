{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
  nixosClass = config.flake.modules.nixos;
in {
  flake.modules.nixos.graphical = {
    lib,
    config,
    ...
  }: {
    imports = [nixosClass.base];
    home-manager.users = hmFor config.mikoshi.users hmClass.graphical;
  };
}
