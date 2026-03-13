{self, ...}: {
  flake.modules.nixos.icons = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      self.modules.nixos.iconsOptions
      self.modules.nixos.homeManager
    ];
    config = lib.mkIf config.mikoshi.icons.enable {
      environment.systemPackages = with pkgs; [
        adwaita-icon-theme
        gnome-themes-extra
      ];
      programs.dconf.enable = true;
      home-manager.sharedModules = [self.modules.homeManager.icons];
    };
  };
}
