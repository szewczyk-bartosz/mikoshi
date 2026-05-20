{config, ...}: {
  flake.nixosModules.mikoshi-plasma = {
    imports = with config.flake.nixosModules; [
      audio
      network
      gc
      ghostty
      tmux
      stylix
      fonts
      icons
      steam
      neovim
      # TODO: Add plasma feature
    ];
  };
}
