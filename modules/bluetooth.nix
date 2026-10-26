{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
  gtkColors = config.flake.lib.gtkColors;
in {
  flake.modules.nixos.bluetooth = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.mikoshi.bluetooth;
  in {
    options.mikoshi.bluetooth = {
      enable = lib.mkEnableOption "bluetooth via blueman with blueman-applet on tray";
    };

    config = lib.mkIf cfg.enable {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.bluetooth;
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      services.blueman.enable = true;
    };
  };

  flake.modules.homeManager.bluetooth = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    services.blueman-applet.enable = true;
  };
}
