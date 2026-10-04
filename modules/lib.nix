{lib, ...}: {
  flake.lib.hmFor = users: module:
    lib.genAttrs users (_: {imports = [module];});

  flake.lib.gtkColors = palette:
    lib.concatStrings
    (lib.mapAttrsToList (name: hex: "@define-color ${name} ${hex};\n") palette);
}
