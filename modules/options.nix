{config, ...}: let
  paletteSetType = config.flake.lib.paletteSetType;
in {
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    options.mikoshi = {
      meta = {
        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Users to configure via home-manager on this host";
        };
        keyboardLayouts = lib.mkOption {
          default = ["gb"];
          type = lib.types.listOf lib.types.str;
          description = "the keyboard layouts to set";
        };
        palette = lib.mkOption {
          type = paletteSetType;
          default = import ./_palette.nix;
          defaultText = lib.literalExpression "import ./_palette.nix";
          description = ''
            Global palette set. Every themed module's own `palette` option
            defaults to this. mikoshi.theme.polarity picks the variant used, and
            still drives the icon theme and GTK colour scheme on its own.
          '';
        };
      };
    };

    # every window manager lives under mikoshi.wm.*; only one may drive a host
    config.assertions = let
      enabled = lib.attrNames (lib.filterAttrs (_: wm: wm.enable or false) (config.mikoshi.wm or {}));
    in [
      {
        assertion = lib.length enabled <= 1;
        message = "mikoshi: at most one window manager may be enabled under mikoshi.wm.*, but these are enabled: ${lib.concatStringsSep ", " enabled}";
      }
    ];
  };
}
