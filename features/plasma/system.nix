{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.plasma.enable {
    console = {
      font = lib.mkDefault "Lat2-Terminus16";
      useXkbConfig = true;
    };

    services.xserver.xkb.layout = lib.mkDefault (lib.concatStringsSep "," config.mikoshi.plasma.kb);

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.dolphin
      kdePackages.ark
      kdePackages.spectacle
      kdePackages.kalk
      kdePackages.okular
      kdePackages.gwenview
    ];

    home-manager.sharedModules = [./home.nix];
  };
}
