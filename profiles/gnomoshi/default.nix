{config, ...}: {
  flake.nixosModules.gnomoshi = {
    imports = with config.flake.nixosModules; [
      globalOptions
      audio
      network
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
