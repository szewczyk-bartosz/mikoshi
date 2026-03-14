{
  osConfig,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.mikoshi.icons.enable {
    gtk = {
      enable = true;
      theme = lib.mkDefault {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
      iconTheme = lib.mkDefault {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      cursorTheme = lib.mkDefault {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
  };
}
