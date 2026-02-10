{self, ...}: {
  flake.modules.nixos.devTools = {
    config,
    lib,
    pkgs,
    ...
  }: {
    # imports = [self.modules.nixos.gnomeOptions];
    # TODO: Add options to this
    config = {
      environment.systemPackages = with pkgs; [
        wget
        git
        rustc
        cargo
        rustfmt
        python313
        maven
        jdk
      ];
    };
  };
}
