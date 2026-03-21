{
  config,
  lib,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.gc.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
