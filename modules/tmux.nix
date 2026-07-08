{...}: {
  flake.modules.homeManager.base = {lib, ...}: {
    programs.tmux = {
      enable = lib.mkDefault true;
      prefix = lib.mkDefault "C-Space";
      keyMode = lib.mkDefault "vi";
      clock24 = lib.mkDefault true;
      escapeTime = lib.mkDefault 0;
      mouse = lib.mkDefault true;
      baseIndex = lib.mkDefault 1;
      historyLimit = lib.mkDefault 10000;
      focusEvents = lib.mkDefault true; # For neovim to work correctly
      terminal = lib.mkDefault "tmux-256color"; # COLOUR
      extraConfig = lib.mkDefault ''
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        bind a last-window
      '';
    };
  };
}
