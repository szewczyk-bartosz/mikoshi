{
  inputs,
  config,
  ...
}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
in {
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users = hmFor config.mikoshi.meta.users hmClass.base;

    console = {
      font = lib.mkDefault "Lat2-Terminus16";
      useXkbConfig = lib.mkDefault true;
    };
    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
    time.timeZone = lib.mkDefault "Europe/London";
    services.xserver.xkb.layout = lib.mkDefault (lib.concatStringsSep "," config.mikoshi.meta.keyboardLayouts);
  };
}
