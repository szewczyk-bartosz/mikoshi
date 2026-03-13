{lib, ...}: {
  options.mikoshi.tmux = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable tmux";
    };
  };
}
