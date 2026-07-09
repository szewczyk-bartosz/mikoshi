{...}: {
  flake.modules.nixos.base = {
    lib,
    config,
    ...
  }: {
    console = {
      font = lib.mkDefault "Lat2-Terminus16";
      useXkbConfig = lib.mkDefault true;
    };
    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
    time.timeZone = lib.mkDefault "Europe/London";
    services.xserver.xkb.layout = lib.mkDefault (lib.concatStringsSep "," config.mikoshi.keyboardLayouts);
  };
}
