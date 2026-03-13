{lib, ...}: {
  options.mikoshi.waybar = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable waybar";
    };
  };
}
