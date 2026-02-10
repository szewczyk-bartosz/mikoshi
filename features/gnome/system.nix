{self, ...}: {
  flake.modules.nixos.gnome = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [self.modules.nixos.gnomeOptions];
    config = lib.mkIf config.mikoshi.gnome.enable {
      # TODO: This entire section should be a seperate feature
      i18n.defaultLocale = "en_US.UTF-8";
      console = {
        font = "Lat2-Terminus16";
        useXkbConfig = true;
      };

      networking.networkmanager.enable = true;
      services.pipewire = {
        enable = true;
        pulse.enable = true;
      };
      environment.variables = {
        GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}";
      };

      programs.dconf.enable = true;
      time.timeZone = "Europe/London"; #TODO: Make this an option
      services.xserver.xkb.layout = config.mikoshi.gnome.kb;

      ##########

      services.displayManager.gdm.enable = true;
      services.xserver.enable = true;
      services.desktopManager.gnome.enable = true;
      services.gnome.core-apps.enable = false;
      programs.seahorse.enable = true;
      programs.evince.enable = true;
      environment.systemPackages = with pkgs; [
        gsettings-desktop-schemas
        gnome-characters
        gnome-calculator
        gnomeExtensions.pop-shell
        loupe
      ];

      home-manager.sharedModules = [self.modules.homeManager.gnome];
    };
  };
}
