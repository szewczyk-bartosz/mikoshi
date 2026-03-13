{self, ...}: {
  flake.modules.nixos.gnome = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      self.modules.nixos.gnomeOptions
      self.modules.nixos.homeManager
    ];
    config = lib.mkIf config.mikoshi.gnome.enable {
      i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
      console = {
        font = lib.mkDefault "Lat2-Terminus16";
        useXkbConfig = true;
      };
      time.timeZone = lib.mkDefault "Europe/London";

      environment.variables = {
        GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}";
      };

      programs.dconf.enable = true;
      services.xserver.xkb.layout = lib.mkDefault config.mikoshi.gnome.kb;

      ##########
      services.displayManager.gdm.enable = true;
      services.xserver.enable = true;
      services.desktopManager.gnome.enable = true;
      services.gnome.core-apps.enable = false;
      programs.seahorse.enable = true;
      programs.evince.enable = true;
      environment.systemPackages = with pkgs; [
        gsettings-desktop-schemas
        nautilus
        gnome-characters
        gnome-calculator
        gnomeExtensions.pop-shell
        loupe
      ];

      home-manager.sharedModules = [self.modules.homeManager.gnome];
    };
  };
}
