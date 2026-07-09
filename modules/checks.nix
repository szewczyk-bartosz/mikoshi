{
  config,
  inputs,
  lib,
  ...
}: let
  testSystems = lib.genAttrs (lib.attrNames config.flake.modules.nixos) (
    name:
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          config.flake.modules.nixos.${name}
          (
            {
              options,
              lib,
              ...
            }: {
              config =
                {
                  system.stateVersion = "26.05";
                  boot.isContainer = true;
                  users.users.testuser.isNormalUser = true;
                }
                // lib.optionalAttrs (options ? mikoshi) {mikoshi.users = ["testuser"];}
                // lib.optionalAttrs (options ? home-manager) {home-manager.users.testuser.home.stateVersion = "26.05";};
            }
          )
        ];
      }
  );
in {
  flake.nixosConfigurations = testSystems;
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    checks = lib.genAttrs (lib.attrNames config.flake.modules.nixos) (name:
      pkgs.runCommand "${name}" {}
      ''
        echo ${
          builtins.unsafeDiscardOutputDependency
          testSystems.${name}.config.system.build.toplevel.drvPath
        } > $out
      '');
  };
}
