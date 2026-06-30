{
  config,
  lib,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.audio.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}
