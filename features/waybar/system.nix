{self, ...}: {
  flake.modules.nixos.hyprshell = {
    config,
    lib,
    ...
  }: {
    imports = [
      self.modules.nixos.waybarOptions
      self.modules.nixos.homeManager
    ];

    config = lib.mkIf config.mikoshi.waybar.enable {
      home-manager.sharedModules = [self.modules.homeManager.waybar];
    };
  };
}
