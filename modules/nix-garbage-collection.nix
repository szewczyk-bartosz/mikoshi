# modules/gc.nix
{...}: {
  flake.modules.nixos.base = {lib, ...}: {
    nix.gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
    nix.settings.min-free = lib.mkDefault (8192 * 1024 * 1024);
    nix.settings.max-free = lib.mkDefault (8192 * 2 * 1024 * 1024);
  };
}
