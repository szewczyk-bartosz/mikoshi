{config, ...}: {
  flake.modules.nixos.cosmic = {
    pkgs,
    lib,
    ...
  }: {
    imports = [config.flake.modules.nixos.graphical];
    config = {
      services.desktopManager.cosmic.enable = lib.mkDefault true;
      services.desktopManager.cosmic.xwayland.enable = lib.mkDefault true;
      services.displayManager.cosmic-greeter.enable = lib.mkDefault true;

      environment.cosmic.excludePackages = lib.mkDefault [];
    };
  };

  flake.modules.homeManager.cosmic = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    config = {
      home.file = {
        ".config/TESTINGTHIS".text = ''
          hello world
        '';
      };
    };
  };
}
