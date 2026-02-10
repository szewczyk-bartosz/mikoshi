{self, ...}: {
  flake.modules.nixos.gnome = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [self.modules.nixos.gnomeOptions];
    config = lib.mkIf config.mikoshi.gnome.enable {
      services.displayManager.gdm.enable = true;
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
