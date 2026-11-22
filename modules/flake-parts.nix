{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules];
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
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
