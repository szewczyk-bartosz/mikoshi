{...}: {
  flake.modules.nixos.graphical = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.mikoshi.graphical.enable {
      environment.systemPackages = with pkgs; [
        ghostty
      ];
    };
  };

  flake.modules.homeManager.graphical = {
    lib,
    pkgs,
    osConfig,
    ...
  }: let
    polarity = osConfig.mikoshi.theme.polarity;
    p = (import ./_palette.nix).${polarity};
    # The palette has no green/blue/cyan, and adding them there would leak into
    # every GTK stylesheet via gtkColors. danger/warning are One Dark's red and
    # yellow, so the missing hues come from One Dark / One Light. ANSI black
    # stays the darkest grey and white the lightest in both modes, as programs
    # printing "black" or "white" text expect.
    terminalColours = {
      dark = {
        green = "#98c379";
        blue = "#61afef";
        cyan = "#56b6c2";
        black = p.overlay;
        brightBlack = p.subtle;
        white = p.text;
        brightWhite = p.text;
      };
      light = {
        green = "#50a14f";
        blue = "#4078f2";
        cyan = "#0184bc";
        black = p.text;
        brightBlack = p.muted;
        white = p.subtle;
        brightWhite = p.overlay;
      };
    };
    extra = terminalColours.${polarity};
    hues = [p.danger extra.green p.warning extra.blue p.accent extra.cyan];
    # 0-7 normal, 8-15 bright
    ansi = [extra.black] ++ hues ++ [extra.white extra.brightBlack] ++ hues ++ [extra.brightWhite];
    cursorShaders = pkgs.fetchFromGitHub {
      owner = "sahaj-b";
      repo = "ghostty-cursor-shaders";
      rev = "0a274beac8b93ee6ce6b94402b7313a0417b8e38";
      hash = "sha256-B7B6K7Ee4uJlW8zzLP3ILgddnbcIQyNimY+rVllzbR0=";
    };
  in {
    config = {
      programs.ghostty = {
        enable = true;
        settings = {
          font-family = lib.mkDefault "JetBrainsMono Nerd Font";
          font-size = lib.mkDefault 12;
          background = lib.mkDefault p.base;
          foreground = lib.mkDefault p.text;
          cursor-color = lib.mkDefault p.accent;
          selection-background = lib.mkDefault p.subtle;
          selection-foreground = lib.mkDefault p.text;
          palette = lib.mkDefault (lib.imap0 (i: hex: "${toString i}=${hex}") ansi);

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
