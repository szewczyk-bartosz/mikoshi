{...}: {
  flake.modules.nixos.graphical = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.mikoshi.graphical.enable {
      services.pipewire = {
        enable = lib.mkDefault true;
        pulse.enable = lib.mkDefault true;
      };
    };
  };
}
