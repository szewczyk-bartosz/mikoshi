# The default mikoshi palette, as a palette set (see paletteSetType in lib.nix).
# Terminal slots not listed fall back to the defaults declared in the type.
{
  dark = {
    base = "#2b2338";
    surface = "#393049";
    overlay = "#453b55";
    subtle = "#554a67";
    text = "#e0daeb";
    muted = "#897d9d";
    accent = "#9d8cc6";
    border = "#9d8cc6";
    danger = "#e06c75";
    warning = "#e5c07b";
    highlight = "#533f75";
    terminal = {
      normal = {
        green = "#c3a6ff";
        blue = "#8fa1e0";
        cyan = "#8ac2c7";
      };
      bright = {
        black = "#554a67";
        red = "#ea8a92";
        green = "#d6c4ff";
        yellow = "#ecd09a";
        blue = "#aab9ea";
        magenta = "#b9aadd";
        cyan = "#a5d3d7";
        white = "#f3f0f9";
      };
    };
  };
  light = {
    base = "#f4f1f9";
    surface = "#e8e4f0";
    overlay = "#ffffff";
    subtle = "#d5cee0";
    text = "#1b1623";
    muted = "#695e7c";
    accent = "#9d8cc6";
    border = "#9d8cc6";
    danger = "#c2414f";
    warning = "#a0701a";
    highlight = "#ddd6ee";
    terminal = {
      normal = {
        black = "#1b1623";
        green = "#7b4fd0";
        blue = "#4a5fb0";
        magenta = "#6e5aa8";
        cyan = "#2f8088";
        white = "#d5cee0";
      };
      bright = {
        black = "#695e7c";
        red = "#d45a66";
        green = "#9168e0";
        yellow = "#b8862e";
        blue = "#6175c4";
        magenta = "#8572bb";
        cyan = "#45969e";
        white = "#ffffff";
      };
    };
  };
}
