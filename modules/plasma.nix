{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
in {
  flake.modules.nixos.plasma = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.mikoshi.wm.plasma;
  in {
    options.mikoshi.wm.plasma = {
      enable = lib.mkEnableOption "KDE Plasma desktop";
      mainMod = lib.mkOption {
        default = "Alt";
        type = lib.types.str;
        description = "Modifier key to use for keybindings (GSettings format, e.g. Alt, Super, Control)";
      };
    };
    config = lib.mkIf cfg.enable {
      mikoshi.graphical.enable = lib.mkDefault true;
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.plasma;
      services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enableQt5Integration = true;

      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        konsole # ghosty ftw
      ];
    };
  };

  flake.modules.homeManager.plasma = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    config = {
      home.packages = with pkgs; [kdePackages.krohnkite];
    };
  };
}
