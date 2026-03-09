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
      virtualisation.docker.enable = true;
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      environment.systemPackages = with pkgs; [
        wget
        git
        rustc
        cargo
        rustfmt
        (python313.withPackages (packages: with packages; [lxml requests tqdm beautifulsoup4 pandas]))
        maven
        jdk
      ];
    };
  };
}
