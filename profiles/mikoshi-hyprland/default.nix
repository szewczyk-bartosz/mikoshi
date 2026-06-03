{config, ...}: {
  flake.nixosModules.mikoshi-hyprland = {
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
