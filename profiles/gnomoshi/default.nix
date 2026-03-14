{config, ...}: {
  flake.nixosModules.gnomoshi = {
    imports = with config.flake.nixosModules; [
      globalOptions
      audio
      network
      gnome
      tmux
      fonts
      icons
      steam
      neovim
    ];
  };
}
