{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules];
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    # alejandra reads stdin when given no paths, and newer `nix fmt` passes none
    formatter = pkgs.writeShellApplication {
      name = "mikoshi-fmt";
      runtimeInputs = [pkgs.alejandra];
      text = ''
        if [ $# -eq 0 ]; then set -- .; fi
        exec alejandra "$@"
      '';
    };
  };
}
