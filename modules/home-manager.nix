{
  config,
  inputs,
  ...
}: let
  hm = config.flake.modules.homeManager;
in {
  flake.modules.nixos.base = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users = lib.genAttrs config.mikoshi.users (name: {
      imports = [hm.base];
    });
  };
}
