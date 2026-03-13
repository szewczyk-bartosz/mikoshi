{self, ...}: {
  flake.modules.nixos.homeManager = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: {
    config = {
      imports = [inputs.home-manager.nixosModules.homeManager];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
  };
}
