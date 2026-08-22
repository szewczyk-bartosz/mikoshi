{inputs, ...}: {
  flake.modules.nixos.bmd = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.mikoshi.bmd;
  in {
    options.mikoshi.bmd = {
      enable = lib.mkEnableOption "bmd";
    };
    config = lib.mkIf cfg.enable {
      environment.systemPackages = [
        inputs.bmd.packages.${pkgs.system}.bmd
      ];
    };
  };
}
