{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.fonts.enable {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf
        nerd-fonts.jetbrains-mono
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
  };
}
