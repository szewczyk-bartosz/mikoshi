{inputs, ...}: {
  flake.modules.nixos.bmd = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.bmd.packages.${pkgs.system}.bmd
    ];
  };
}
