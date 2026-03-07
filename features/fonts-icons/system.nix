{self, ...}: {
  flake.modules.nixos.hyprland = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [self.modules.nixos.fontsIconsOptions];
    config = lib.mkIf config.mikoshi.fontsIcons.enable {
      fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-emoji
          liberation_ttf
          (nerdfonts.ovvrride {fonts = ["JetBrainsMono"];})
        ];
        fontconfig = {
          defaultFonts = {
            serif = ["Noto Serif"];
            sansSerif = ["Noto Sans"];
            monospace = ["JetBrainsMono Nerd Font"];
            emoji = ["Noto Color Emoji"];
          };
        };
      };
      environment.systemPackages = with pkgs; [
        adwaita-icon-theme
        gnome-themes-extra
      ];
      programs.dconf.enable = true;
      home-manager.sharedModules = [self.modules.homeManager.fontsIcons];
    };
  };
}
