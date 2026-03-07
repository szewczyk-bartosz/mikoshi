{...}: {
  flake.modules.nixos.hyprlandOptions = {
    lib,
    pkgs,
    ...
  }: {
    options.mikoshi.hyprland = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable fonts and icons, sets some sane defaults so the system looks ok";
      };

      # TODO: Actually do the options for this
    };
  };
}
