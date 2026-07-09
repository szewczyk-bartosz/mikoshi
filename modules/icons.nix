{...}: {
  flake.modules.nixos.graphical = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
      gnome-themes-extra
    ];
    programs.dconf.enable = true;
  };

  flake.modules.homeManager.graphical = {
    lib,
    pkgs,
    ...
  }: {
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
    };
    home.pointerCursor = lib.mkDefault {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };
    qt = {
      enable = true;
      platformTheme.name = lib.mkDefault "gtk3";
      style.name = lib.mkDefault "adwaita";
    };
  };
}
