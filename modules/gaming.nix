{...}: {
  flake.modules.nixos.gaming = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.mikoshi.gaming;
  in {
    options.mikoshi.gaming = {
      enable = lib.mkEnableOption "gaming support";
    };

    config = lib.mkIf cfg.enable {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      nixpkgs.config.allowUnfree = true;
      programs.steam.enable = true;
      programs.gamemode.enable = true;

      services.scx.enable = true;
      services.scx.scheduler = "scx_bpfland";

      environment.systemPackages = with pkgs; [
        protonup-qt
        heroic
      ];
    };
  };
}
