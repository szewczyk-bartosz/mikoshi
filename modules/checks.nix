{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.ci-test = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.modules.nixos.base
      config.flake.modules.nixos.nvim
      config.flake.modules.nixos.bmd
      config.flake.modules.nixos.graphical
      config.flake.modules.nixos.gaming

      {
        mikoshi.users = ["testuser"];
        users.users.testuser.isNormalUser = true;
        home-manager.users.testuser.home.stateVersion = "25.05";
        system.stateVersion = "25.05";
        boot.isContainer = true;
      }
    ];
  };

  perSystem = {pkgs, ...}: {
    checks.mikoshi-eval-only = pkgs.runCommand "mikoshi-eval-only" {} ''
      echo ${
        builtins.unsafeDiscardOutputDependency
        config.flake.nixosConfigurations.ci-test.config.system.build.toplevel.drvPath
      } > $out
    '';
  };
}
