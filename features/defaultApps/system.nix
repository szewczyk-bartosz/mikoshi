{pkgs, ...}: {
  # TODO: Add options to this
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # anki
    chromium
    ghostty
    jetbrains.idea
    brave
    firefox
    claude-code
    discord
    keepassxc
    spotify
  ];
}
