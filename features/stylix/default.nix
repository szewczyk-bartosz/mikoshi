{
  config,
  inputs,
  ...
}: {
  flake.nixosModules.stylix = {
    imports = [./system.nix config.flake.nixosModules.home-manager inputs.stylix.nixosModules.default];
  };
}
