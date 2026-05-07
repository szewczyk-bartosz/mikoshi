{
  description = "Mikoshi - A samurai's nixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";

    bmd = {
      url = "github:szewczyk-bartosz/my-markdown-lang";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        ./features/gc
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
        ./features/bmd

        ./profiles/gnomoshi
        ./profiles/hyprlandoshi
      ];
    };
}
