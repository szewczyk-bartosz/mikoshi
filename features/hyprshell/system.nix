{
  config,
  lib,
  ...
}: {
  imports = [
    ./options.nix
    ../home-manager/default.nix
  ];
  config = lib.mkIf config.mikoshi.hyprshell.enable {
    home-manager.sharedModules = [./home.nix];
  };
}
