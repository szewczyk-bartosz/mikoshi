{
  inputs,
  config,
  ...
}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: let
    testSystem = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        config.flake.modules.nixos.base
        {
          mikoshi.users = ["testuser"];
          users.users.testuser.isNormalUser = true;
          home-manager.users.testuser.home.stateVersion = "26.05";
          system.stateVersion = "26.05";
          boot.loader.grub.enable = false;
          boot.isContainer = true;
        }
      ];
    };
  in {
    checks.mikoshi-check = pkgs.runCommand "check-mikoshi" {} ''
      echo ${testSystem.config.system.build.toplevel.drvPath} > $out
    '';
  };
}
