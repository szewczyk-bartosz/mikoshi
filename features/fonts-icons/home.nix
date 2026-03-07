{...}: {
  flake.modules.homeManager.fontsIcons = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    workspaces = builtins.genList (x: x) 10;
  in {
    config = lib.mkIf osConfig.mikoshi.fontsIcons.enable {
      gtk = {
        enable = true;
        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
        cursorTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
      };
    };
  };
}
