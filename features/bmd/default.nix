{inputs, ...}: {
  flake.nixosModules.bmd = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.bmd.packages.${pkgs.system}.bmd
    ];
  };
}
