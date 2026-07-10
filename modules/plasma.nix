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
      services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enableQt5Integration = true;

      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        konsole # ghosty ftw
      ];
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
