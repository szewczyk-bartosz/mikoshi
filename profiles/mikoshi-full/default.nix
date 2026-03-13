{config, ...}: {
  flake.nixosModules.mikoshiFull = {
    imports = with config.flake.nixosModules; [
      globalOptions
      hyprland
      hyprshell
    ];
  };
}
