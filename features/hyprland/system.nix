{
  config,
  lib,
  ...
}: {
  imports = [
    ./options.nix
    ../home-manager/default.nix
  ];
  config = lib.mkIf config.mikoshi.hyprland.enable {
    programs.hyprland.enable = true;
    home-manager.sharedModules = [./home.nix];
  };
}
