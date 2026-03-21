{config, ...}: {
  flake.nixosModules.gnomoshi = {
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
