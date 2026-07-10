{lib, ...}: {
  flake.lib.hmFor = users: module:
    lib.genAttrs users (_: {imports = [module];});
}
