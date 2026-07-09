{...}: {
  flake.modules.nixos.base = {lib, ...}: {
    options.mikoshi = {
      users = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Users to configure via home-manager on this host";
      };
      keyboardLayouts = {
        default = ["gb"];
        type = lib.types.listOf lib.types.str;
        description = "the keyboard layouts to set";
      };
    };
  };
}
