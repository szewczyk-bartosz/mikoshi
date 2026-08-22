{
  config,
  lib,
  ...
}: {
  flake.modules.nixos.default = {
    imports = lib.attrValues (removeAttrs config.flake.modules.nixos ["default"]);
  };
}
