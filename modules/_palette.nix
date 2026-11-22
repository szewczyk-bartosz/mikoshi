# The default mikoshi palette, as a palette set (see paletteSetType in lib.nix).
# Terminal slots not listed fall back to the defaults declared in the type.
{
  dark = {
    base = "#2b2b30";
    surface = "#3a3a3f";
    overlay = "#45454b";
    subtle = "#55555c";
    text = "#e0e0e5";
    muted = "#8a8a90";
    accent = "#9d8cc6";
    border = "#9d8cc6";
    danger = "#e06c75";
    warning = "#e5c07b";
    highlight = "#4a4360";
    terminal = {
      normal = {
        green = "#92c4a1";
        blue = "#8fa1e0";
        cyan = "#8ac2c7";
      };
      bright = {
        black = "#55555c";
        red = "#ea8a92";
        green = "#aed6b9";
        yellow = "#ecd09a";
        blue = "#aab9ea";
        magenta = "#b9aadd";
        cyan = "#a5d3d7";
        white = "#f4f4f8";
      };
    };
  };
  light = {
    base = "#f4f4f6";
    surface = "#e8e8ec";
    overlay = "#ffffff";
    subtle = "#d4d4da";
    text = "#1a1a1f";
    muted = "#6a6a70";
    accent = "#9d8cc6";
    border = "#9d8cc6";
    danger = "#c2414f";
    warning = "#a0701a";
    highlight = "#ddd6ee";
    terminal = {
      normal = {
        black = "#1a1a1f";
        green = "#3a7a4e";
        blue = "#4a5fb0";
        magenta = "#6e5aa8";
        cyan = "#2f8088";
        white = "#d4d4da";
      };
      bright = {
        black = "#6a6a70";
        red = "#d45a66";
        green = "#4e9163";
        yellow = "#b8862e";
        blue = "#6175c4";
        magenta = "#8572bb";
        cyan = "#45969e";
        white = "#ffffff";
      };
    };
  };
}
