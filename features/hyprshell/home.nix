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
              key = "space"; # TODO: make this into an option
              modifier = "alt"; # TODO: this as well
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
