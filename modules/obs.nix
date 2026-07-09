{...}: {
  flake.modules.nixos.obs-amd = {
    pkgs,
    lib,
    ...
  }: {
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
      ];
    };
  };
}
