{config, ...}: {
  flake.nixosModules.gnomoshi = {
    imports = with config.flake.nixosModules; [
      globalOptions
      audio
      network
      gnome
      defaultApps
      devTools
      tmux
      fonts
      icons
      steam
      neovim
    ];
  };
}
