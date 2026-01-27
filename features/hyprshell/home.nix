{...}: {
  flake.modules.homeManager.hyprshell = {
    osConfig,
    lib,
    ...
  }: {
    config = lib.mkIf osConfig.mikoshi.hyprshell.enable {
      services.hyprshell = {
        enable = lib.mkDefault true;
        systemd.enable = lib.mkDefault true;
        settings = lib.mkDefault {
          windows = {
            launcher = {
              key = "super_l"; # TODO: make this into an option
            };
            switch = {
              modifier = "alt"; #TODO: and this
            };
          };
        };
      };
    };
  };
}
