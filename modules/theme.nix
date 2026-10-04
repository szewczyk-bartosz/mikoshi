{
  flake.modules.nixos.theme = {lib, ...}: {
    options.mikoshi.theme.polarity = lib.mkOption {
      type = lib.types.enum ["dark" "light"];
      default = "dark";
      description = "Colour scheme used by every themed surface.";
    };
  };
}
