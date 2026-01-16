{self, ...}: {
  flake.nixosModules.hyprland = {
    config,
    lib,
    ...
  }: {
    imports = [self.nixosModules.options];
    config = lib.mkIf config.mikoshi.hyprland.enable {
      programs.hyprland.enable = true;
    };
  };

  flake.homeManagerModules.hyprland = {
    osConfig,
    lib,
    ...
  }: {
    config = lib.mkIf osConfig.mikoshi.hyprland.enable {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          input.kb_layout = osConfig.mikoshi.hyprland.keyboardLayout;
          monitor = osConfig.mikoshi.hyprland.monitors;
        };
      };
    };
  };
}
