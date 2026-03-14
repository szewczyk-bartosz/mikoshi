{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.ghostty.enable {
    environment.systemPackages = with pkgs; [
      ghostty
    ];

    home-manager.sharedModules = [./home.nix];
  };
}
