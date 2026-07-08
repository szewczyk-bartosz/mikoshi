# modules/gc.nix
{...}: {
  flake.modules.nixos.base = {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
