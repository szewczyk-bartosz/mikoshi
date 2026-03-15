{
  description = "Mikoshi - A samurai's nixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprshell = {
      url = "github:H3rmt/hyprshell?ref=hyprshell-release";
      inputs.hyprland.follows = "hyprland";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    mikoshi-neovim.url = "github:szewczyk-bartosz/mikoshi-neovim";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        ./features/home-manager
        ./features/ghostty
        ./features/stylix
        ./features/audio
        ./features/fonts
        ./features/gnome
        ./features/hyprland
        ./features/icons
        ./features/neovim
        ./features/network
        ./features/steam
        ./features/tmux

        ./profiles/gnomoshi
        ./profiles/mikoshi-full
      ];
    };
}
