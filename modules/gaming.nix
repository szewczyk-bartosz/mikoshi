{...}: {
  flake.modules.nixos.gaming = {
    pkgs,
    lib,
    ...
  }: {
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
}
