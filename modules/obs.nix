{...}: {
  flake.modules.nixos.obs-amd = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.mikoshi.obs-amd;
  in {
    options.mikoshi.obs-amd = {
      enable = lib.mkEnableOption "OBS Studio with VAAPI hardware encoding (AMD GPUs only: forces the radeonsi driver)";
    };
    config = lib.mkIf cfg.enable {
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [libva-vdpau-driver];
      };


      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "radeonsi";
      };

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-vaapi
          obs-pipewire-audio-capture
        ];
      };
    };
  };
}
