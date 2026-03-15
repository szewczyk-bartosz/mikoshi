{
  config,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {
    _module.args.inputs = inputs;
    imports = [./system.nix config.flake.nixosModules.home-manager];
  };
}
