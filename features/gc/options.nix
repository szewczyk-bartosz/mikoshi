{lib, ...}: {
  options.mikoshi.gc = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable automatic Nix garbage collection";
    };
  };
}
