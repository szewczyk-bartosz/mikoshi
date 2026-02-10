{...}: {
  flake.modules.nixos.gnomeOptions = {
    lib,
    pkgs,
    ...
  }: {
    options.mikoshi.hyprland = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable Mikoshi's hyprland setup";
      };
    };
  };
}
