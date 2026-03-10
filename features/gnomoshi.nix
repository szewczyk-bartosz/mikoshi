{config, ...}: {
  flake.modules.nixos.gnomoshi = {
    imports = with config.flake.modules.nixos; [
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
