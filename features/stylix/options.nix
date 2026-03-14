{lib, ...}: {
  options.mikoshi.stylix = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable stylix";
    };
    base16Scheme = lib.mkOption {
      default = "eris";
      type = lib.types.str;
      description = "the base 16 theme to use";
    };
  };
}
