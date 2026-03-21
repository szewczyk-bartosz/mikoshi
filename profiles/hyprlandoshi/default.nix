{config, ...}: {
  flake.nixosModules.hyprlandoshi = {
    imports = with config.flake.nixosModules; [
      hyprland
      audio
      network
      gc
      ghostty
      stylix
      tmux
      fonts
      icons
      neovim
    ];
  };
}
