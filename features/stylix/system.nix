{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.stylix.enable {
    stylix = {
      enable = true;
      base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/${config.mikoshi.stylix.base16Scheme}.yaml";
    };
    home-manager.sharedModules = [./home.nix];
  };
}
