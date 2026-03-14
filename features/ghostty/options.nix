{lib, ...}: {
  options.mikoshi.ghostty = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable ghostty";
    };
  };
}
