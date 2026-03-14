{
  config,
  lib,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.hyprland.enable {
    programs.hyprland.enable = true;
    home-manager.sharedModules = [./home.nix ./waybar.nix];
  };
}
