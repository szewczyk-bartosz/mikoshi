{self, ...}: {
  flake.modules.nixos.steam = {
    config,
    lib,
    pkgs,
    ...
  }: {
    config = {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      programs.steam.enable = true;
      programs.gamemode.enable = true;

      environment.systemPackages = with pkgs; [
        protonup-qt
      ];
    };
  };
}
