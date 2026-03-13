{lib, ...}: {
  options.mikoshi.audio = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable Mikoshi's audio setup";
    };
  };
}
