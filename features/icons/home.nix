{...}: {
  flake.modules.homeManager.icons = {
    osConfig,
    lib,
    pkgs,
    ...
  }: {
    config = lib.mkIf osConfig.mikoshi.icons.enable {
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
