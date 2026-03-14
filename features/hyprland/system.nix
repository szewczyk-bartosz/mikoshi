{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.hyprland.enable {
    programs.hyprland.enable = true;
    home-manager.sharedModules = [./home.nix ./waybar.nix];

    environment.systemPackages = with pkgs; [
      playerctl
      pavucontrol
      wlogout
      brightnessctl
      waybar
      swaynotificationcenter
      networkmanagerapplet
      xdg-desktop-portal-hyprland
      lxqt.lxqt-policykit
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
      config.common.default = "*";
    };
  };
}
