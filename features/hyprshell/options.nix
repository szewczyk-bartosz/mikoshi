{lib, ...}: {
  options.mikoshi.hyprshell = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable hyprshell";
    };
  };
}
