{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
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
    config = lib.mkIf cfg.enable {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.graphical;
    };
  };
}
