{self, ...}: {
  flake.nixosModules.default = {
    config,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.options
      self.nixosModules.hyprland
    ];

    # Apply the home-manager configuration to all non-root users
    home-manager.users = lib.mapAttrs (username: _: {
      imports = [self.homeManagerModules.hyprland];
    }) (lib.filterAttrs (username: _: username != "root") config.users.users);
  };
}
