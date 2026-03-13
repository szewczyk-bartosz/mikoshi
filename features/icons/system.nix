{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./options.nix
    ../home-manager/default.nix
  ];
  config = lib.mkIf config.mikoshi.icons.enable {
    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
      gnome-themes-extra
    ];
    programs.dconf.enable = true;
    home-manager.sharedModules = [./home.nix];
  };
}
