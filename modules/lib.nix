{lib, ...}: let
  inherit (lib) mkOption types literalExpression;

  hex = types.strMatching "#[0-9a-fA-F]{6}";
  colour = description:
    mkOption {
      type = hex;
      inherit description;
    };
  # a colour that falls back to `fallback` (a value) shown as `text` in the docs
  derived = description: fallback: text:
    mkOption {
      type = hex;
      default = fallback;
      defaultText = literalExpression text;
      inherit description;
    };

  ansiSlots = ["black" "red" "green" "yellow" "blue" "magenta" "cyan" "white"];

  # One polarity's worth of colours. Core colours and terminal green/blue/cyan
  # are required; the other ANSI slots default to the core colour they mean,
  # and every bright slot defaults to its normal one.
  paletteType = types.submodule ({config, ...}: {
    options = {
      base = colour "Window and terminal background.";
      surface = colour "Raised surfaces: bars, headers, sidebars.";
      overlay = colour "Cards and popovers above surface.";
      subtle = colour "Borders and inactive elements.";
      text = colour "Primary foreground.";
      muted = colour "Secondary foreground.";
      accent = colour "Accent: focus, cursor, active elements.";
      border = colour "Focused borders.";
      danger = colour "Errors and urgent states.";
      warning = colour "Warnings.";
      highlight = colour "Selected text background.";

      terminal.normal = {
        black = derived "ANSI 0. Should stay the darkest grey in both polarities." config.overlay "config.overlay";
        red = derived "ANSI 1." config.danger "config.danger";
        green = colour "ANSI 2.";
        yellow = derived "ANSI 3." config.warning "config.warning";
        blue = colour "ANSI 4.";
        magenta = derived "ANSI 5." config.accent "config.accent";
        cyan = colour "ANSI 6.";
        white = derived "ANSI 7. Should stay the lightest grey in both polarities." config.text "config.text";
      };

      terminal.bright =
        lib.genAttrs ansiSlots (slot:
          derived "ANSI ${slot}, bright variant (8-15)." config.terminal.normal.${slot} "config.terminal.normal.${slot}");
    };
  });

  # A palette may define only the polarities it supports.
  paletteSetType = types.submodule {
    options = lib.genAttrs ["dark" "light"] (polarity:
      mkOption {
        type = types.nullOr paletteType;
        default = null;
        description = "The ${polarity} variant, or null if this palette has none.";
      });
  };
in {
  flake.lib.hmFor = users: module:
    lib.genAttrs users (_: {imports = [module];});

  # only top-level colours; nested sets like `terminal` stay out of the CSS
  flake.lib.gtkColors = palette:
    lib.concatStrings
    (lib.mapAttrsToList (name: hex: "@define-color ${name} ${hex};\n")
      (lib.filterAttrs (_: builtins.isString) palette));

  flake.lib.ansiSlots = ansiSlots;
  flake.lib.paletteType = paletteType;
  flake.lib.paletteSetType = paletteSetType;

  # per-module palette option, defaulting to the global one
  flake.lib.paletteOption = global:
    mkOption {
      type = paletteSetType;
      default = global;
      defaultText = literalExpression "config.mikoshi.meta.palette";
      description = "Palette for this module. Defaults to the global palette; may define only one polarity, but must define the one mikoshi.theme.polarity selects.";
    };

  # pick the variant for the system's polarity, failing loudly if it's missing
  flake.lib.resolvePalette = where: set: polarity: let
    defined = lib.attrNames (lib.filterAttrs (_: v: v != null) set);
  in
    if set.${polarity} or null != null
    then set.${polarity}
    else
      throw "mikoshi: ${where} palette has no '${polarity}' variant, but mikoshi.theme.polarity = \"${polarity}\" (defined: ${
        if defined == []
        then "none"
        else lib.concatStringsSep ", " defined
      })";
}
