{config, ...}: let
  paletteOption = config.flake.lib.paletteOption;
  resolvePalette = config.flake.lib.resolvePalette;
  ansiSlots = config.flake.lib.ansiSlots;
in {
  flake.modules.nixos.graphical = {
    config,
    pkgs,
    lib,
    ...
  }: {
    options.mikoshi.ghostty.palette = paletteOption config.mikoshi.meta.palette;

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
    p = resolvePalette "mikoshi.ghostty" osConfig.mikoshi.ghostty.palette polarity;
    t = p.terminal;
    # 0-7 normal, 8-15 bright
    ansi = map (slot: t.normal.${slot}) ansiSlots ++ map (slot: t.bright.${slot}) ansiSlots;
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
          selection-background = lib.mkDefault p.highlight;
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
