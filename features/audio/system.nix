{self, ...}: {
  flake.modules.nixos.audio = {
    config,
    lib,
    ...
  }: {
    imports = [self.modules.nixos.audioOptions];
    config = lib.mkIf config.mikoshi.audio.enable {
      services.pipewire = {
        enable = true;
        pulse.enable = true;
      };
    };
  };
}
