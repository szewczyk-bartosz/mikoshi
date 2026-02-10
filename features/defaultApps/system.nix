{self, ...}: {
  flake.modules.nixos.defaultApps = {
    config,
    lib,
    pkgs,
    ...
  }: {
    # imports = [self.modules.nixos.gnomeOptions];
    # TODO: Add options to this
    config = {
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        anki
        chromium
        ghostty
        jetbrains.idea
        brave
      ];
    };
  };
}
