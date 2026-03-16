{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.hyprland.enable {
    programs.hyprland.enable = true;
    home-manager = {
      sharedModules = [./home.nix ./waybar.nix];
    };

    environment.systemPackages = with pkgs; [
      rofi
      playerctl
      pavucontrol
      wlogout
      brightnessctl
      waybar
      swaynotificationcenter
      networkmanagerapplet
      lxqt.lxqt-policykit
    ];

    xdg.portal = {
      enable = true;
      config.common.default = "*";
    };
  };
}
