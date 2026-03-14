{config, ...}: {
  flake.nixosModules.gnomoshi = {
    imports = with config.flake.nixosModules; [
      audio
      network
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
