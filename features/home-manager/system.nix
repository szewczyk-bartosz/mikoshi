{self, ...}: {
  flake.modules.nixos.homeManager = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: {
    imports = [inputs.home-manager.nixosModules.homeManager];
    config = {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
  };
}
