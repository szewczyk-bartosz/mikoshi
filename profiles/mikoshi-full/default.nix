{config, ...}: {
  flake.nixosModules.mikoshiFull = {
    imports = with config.flake.nixosModules; [
      hyprland
      audio
      network
      ghostty
      stylix
      tmux
      fonts
      icons
      neovim
    ];
  };
}
