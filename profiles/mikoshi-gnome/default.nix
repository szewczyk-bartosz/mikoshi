{config, ...}: {
  flake.nixosModules.mikoshi-gnome = {
    imports = with config.flake.nixosModules; [
      audio
      network
      gc
      ghostty
      gnome
      tmux
      stylix
      fonts
      icons
      steam
      neovim
    ];
  };
}
