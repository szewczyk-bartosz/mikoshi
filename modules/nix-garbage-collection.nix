{...}: {
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: let
    cfg = config.mikoshi.nixGarbageCollection;
  in {
    options.mikoshi.nixGarbageCollection = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable automatic Nix garbage collection";
      };
    };
    config = lib.mkIf cfg.enable {
      nix.gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "weekly";
        options = lib.mkDefault "--delete-older-than 30d";
      };
      nix.settings.min-free = lib.mkDefault (8192 * 1024 * 1024);
      nix.settings.max-free = lib.mkDefault (8192 * 2 * 1024 * 1024);
    };
  };
}
