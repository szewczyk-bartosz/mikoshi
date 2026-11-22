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
      enable = lib.mkEnableOption "bmd, the BMD / Engram block-markup tool from engramware";
    };
    config = lib.mkIf cfg.enable {
      environment.systemPackages = [
        inputs.bmd.packages.${pkgs.stdenv.hostPlatform.system}.bmd
      ];
    };
  };
}
