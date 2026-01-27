{...}: {
  flake.modules.homeManager.waybar = {
    osConfig,
    lib,
    ...
  }: {
    config = lib.mkIf osConfig.mikoshi.waybar.enable {
      programs.waybar = {
        enable = lib.mkDefault true;
        systemd.enable = lib.mkDefault true;
      };
    };
  };
}
