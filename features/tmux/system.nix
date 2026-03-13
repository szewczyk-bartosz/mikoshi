{
  config,
  lib,
  ...
}: {
  imports = [
    ./options.nix
    ../home-manager/default.nix
  ];
  config = lib.mkIf config.mikoshi.tmux.enable {
    home-manager.sharedModules = [./home.nix];
  };
}
