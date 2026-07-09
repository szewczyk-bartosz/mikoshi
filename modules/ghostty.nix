{...}: {
  flake.modules.nixos.graphical = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      ghostty
    ];
  };

  flake.modules.homeManager.graphical = {
    lib,
    pkgs,
    ...
  }: let
    cursorShaders = pkgs.fetchFromGitHub {
      owner = "sahaj-b";
      repo = "ghostty-cursor-shaders";
      rev = "0a274beac8b93ee6ce6b94402b7313a0417b8e382";
      hash = lib.fakeHash;
    };
  in {
    config = {
      programs.ghostty = {
        enable = true;
        settings = {
          font-family = lib.mkDefault "JetBrainsMono Nerd Font";
          font-size = lib.mkDefault 12;
          theme = lib.mkDefault "catppuccin-mocha";

          cursor-style = lib.mkDefault "bar";
          cursor-style-blink = lib.mkDefault false;

          custom-shader = lib.mkDefault ["${cursorShaders}/cursor_warp.glsl" "${cursorShaders}/ripple_cursor.glsl"];
          custom-shader-animation = lib.mkDefault "always";

          window-padding-x = lib.mkDefault 8;
          window-padding-y = lib.mkDefault 8;
        };
      };
    };
  };
}
