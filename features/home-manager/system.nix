{self, ...}: {
  flake.modules.nixos.homeManager = {
    config,
    lib,
    pkgs,
    ...
  }: {
    config = {
      programs.home-manager.enable = true;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
  };
}
