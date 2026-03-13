{...}: {
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    keyMode = "vi";
    clock24 = true;
    escapeTime = 0;
    mouse = true;
    baseIndex = 1;
    historyLimit = 10000;
    focusEvents = true; # For neovim to work correctly
    terminal = "tmux-256color"; # COLOUR
    extraConfig = ''
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind a last-window
    '';
  };
}
