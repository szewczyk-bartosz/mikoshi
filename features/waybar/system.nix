{
  config,
  lib,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.waybar.enable {
    home-manager.sharedModules = [./home.nix];
  };
}
