{config, ...}: {
  flake.modules.nixos.gnomoshi = {
    imports = with config.flake.modules.nixos; [
      globalOptions
      gnome
      defaultApps
      devTools
    ];
  };
}
