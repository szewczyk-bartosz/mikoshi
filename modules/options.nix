{...}: {
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
