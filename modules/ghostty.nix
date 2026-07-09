{...}: {
  flake.modules.nixos.graphical = {
    pkgs,
    lib,
    ...
  }: {
    config = {
      environment.systemPackages = with pkgs; [
        ghostty
      ];
    };
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
          font-family = "JetBrainsMono Nerd Font";
          font-size = 12;

          cursor-style = "bar";
          cursor-style-blink = false;

          custom-shader = ["${cursorShaders}/cursor_warp.glsl" "${cursorShaders}/ripple_cursor.glsl"];
          custom-shader-animation = "always";

          window-padding-x = 8;
          window-padding-y = 8;
        };
      };
    };
  };
}
