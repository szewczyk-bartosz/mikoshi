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
  };
}
