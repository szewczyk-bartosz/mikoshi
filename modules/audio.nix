{...}: {
  flake.modules.nixos.graphical = {lib, ...}: {
    services.pipewire = {
      enable = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
    };
  };
}
