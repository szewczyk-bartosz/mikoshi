{config, ...}: {
  flake.nixosModules.hyprlandoshi = {
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
