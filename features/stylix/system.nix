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
      base16Scheme = lib.mkDefault (
        if builtins.pathExists ./themes/${config.mikoshi.stylix.base16Scheme}.yaml
        then ./themes/${config.mikoshi.stylix.base16Scheme}.yaml
        else "${pkgs.base16-schemes}/share/themes/${config.mikoshi.stylix.base16Scheme}.yaml"
      );
      polarity = "dark";
    };
    home-manager.sharedModules = [./home.nix];
  };
}
