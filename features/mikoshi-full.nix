{config, ...}: {
  flake.modules.nixos.mikoshiFull = {
    imports = with config.flake.modules.nixos; [
      globalOptions
      hyprland
      hyprshell
    ];
  };
}
