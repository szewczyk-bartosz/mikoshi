{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      sharedModules = [./home.nix ./waybar.nix];
    };

    environment.systemPackages = with pkgs; [
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
