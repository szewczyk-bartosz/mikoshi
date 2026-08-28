{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
in {
  flake.modules.nixos.sway = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.mikoshi.sway;
  in {
    options.mikoshi.sway = {
      enable = lib.mkEnableOption "Sway desktop";
    };
    config = lib.mkIf cfg.enable {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.sway;
    };
  };

  flake.modules.homeManager.sway = {
    lib,
    pkgs,
    osConfig,
    ...
  }: let
    cfg = osConfig.mikoshi.sway;
  in {
    config = {};
  };
}
