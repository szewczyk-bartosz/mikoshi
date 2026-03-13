{
  config,
  lib,
  ...
}: {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.tmux.enable {
    home-manager.sharedModules = [./home.nix];
  };
}
