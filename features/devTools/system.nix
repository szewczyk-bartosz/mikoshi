{pkgs, ...}: {
  # TODO: Add options to this
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
}
