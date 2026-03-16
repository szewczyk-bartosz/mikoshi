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
    # Not sure how I feel about this, this might be lighter but I think I prefer the look of the gnome one
    # services.greetd = {
    #   enable = true;
    #   settings = {
    #     default_session = {
    #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
    #       user = "greeter";
    #     };
    #   };
    # };
    services.displayManager.gdm.enable = true;
    services.displayManager.gdm.wayland = true;
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
