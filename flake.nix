{
  description = "Mikoshi - A samurai's nixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    mikoshi-neovim.url = "github:szewczyk-bartosz/mikoshi-neovim";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        ./features/options
        ./features/audio
        ./features/defaultApps
        ./features/devTools
        ./features/fonts
        ./features/gnome
        ./features/hyprland
        ./features/hyprshell
        ./features/icons
        ./features/neovim
        ./features/network
        ./features/steam
        ./features/tmux
        ./features/waybar
        ./profiles/gnomoshi
        ./profiles/mikoshi-full
      ];
    };
}
