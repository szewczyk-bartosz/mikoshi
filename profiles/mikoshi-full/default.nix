{config, ...}: {
  flake.nixosModules.mikoshiFull = {
    imports = with config.flake.nixosModules; [
      hyprland
      audio
      network
      ghostty
      tmux
      fonts
      icons
      neovim
    ];
  };
}
