{
  description = "Mikoshi - A samurai's nixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    bmd = {
      url = "github:szewczyk-bartosz/engramware";
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
        ./features/plasma
        ./features/hyprland
        ./features/icons
        ./features/neovim
        ./features/network
        ./features/steam
        ./features/tmux
        ./features/bmd

        ./profiles/mikoshi-gnome
        ./profiles/mikoshi-hyprland
        ./profiles/mikoshi-plasma
      ];
    };
}
