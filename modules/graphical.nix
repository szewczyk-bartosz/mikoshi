{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
  nixosClass = config.flake.modules.nixos;
in {
  flake.modules.nixos.graphical = {
    lib,
    config,
    ...
  }: let
    cfg = config.mikoshi.graphical;
  in {
    options.mikoshi.graphical = {
      enable = lib.mkEnableOption "graphical/desktop support";
    };
    imports = [nixosClass.base];
    config = lib.mkIf cfg.enable {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.graphical;
    };
  };
}
