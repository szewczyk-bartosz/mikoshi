{...}: {
  flake.modules.nixos.base = {lib, ...}: {
    options.mikoshi.users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Users to configure via home-manager on this host";
    };
  };
}
