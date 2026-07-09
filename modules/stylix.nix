{inputs, ...}: {
  flake.modules.nixos.base = {
    lib,
    pkgs,
    config,
    ...
  }: {
    imports = [inputs.stylix.nixosModules.default];

    config = {
      stylix = {
        # Disable stylix for neovim as its not that good at doing it
        targets.nvf.enable = false;

        # Stylix disabled for now, I feel that it will require some hand tuning
        # and to be honest, I feel that the full system having a consistent non-neutral
        # colour theme feels a bit... cheap? weird?
        enable = false;
        base16Scheme = lib.mkDefault (
          if builtins.pathExists ./themes/${config.mikoshi.stylix.base16Scheme}.yaml
          then ./themes/${config.mikoshi.stylix.base16Scheme}.yaml
          else "${pkgs.base16-schemes}/share/themes/${config.mikoshi.stylix.base16Scheme}.yaml"
        );
        polarity = "dark";
      };
    };
    options.mikoshi.stylix = {
      base16Scheme = lib.mkOption {
        default = "catppuccin-mocha";
        type = lib.types.str;
        description = "the base 16 theme to use";
      };
    };
  };
}
