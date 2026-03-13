{
  config,
  lib,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.hyprshell.enable {
    home-manager.sharedModules = [./home.nix];
  };
}
