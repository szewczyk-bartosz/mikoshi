{config, ...}: {
  flake.modules.nixos.gnomoshi = {
    imports = with config.flake.modules.nixos; [
      globalOptions
      hyprland
      hyprshell
    ];
  };
}
