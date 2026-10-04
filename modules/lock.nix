{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
in {
  flake.modules.nixos.lock = {
    config,
    lib,
    ...
  }: {
    options.mikoshi.lock.enable = lib.mkEnableOption "swaylock screen locker and swayidle";

    config = lib.mkIf config.mikoshi.lock.enable {
      # without a PAM service swaylock can never unlock
      security.pam.services.swaylock = {};

      home-manager.users = hmFor config.mikoshi.meta.users hmClass.lock;
    };
  };

  flake.modules.homeManager.lock = {
    config,
    lib,
    pkgs,
    osConfig,
    ...
  }: let
    palette = (import ./_palette.nix).${osConfig.mikoshi.theme.polarity};
    # swaylock wants RRGGBB[AA] without the leading #
    c = name: lib.removePrefix "#" palette.${name};
    lock = "${lib.getExe config.programs.swaylock.package} -f";
    swaymsg = "${osConfig.programs.sway.package}/bin/swaymsg";
  in {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        screenshots = true;
        effect-blur = "8x4";
        effect-vignette = "0.5:0.5";
        fade-in = 0.2;

        clock = true;
        timestr = "%H:%M";
        datestr = "%a %d %b";
        indicator = true;
        indicator-radius = 96;
        indicator-thickness = 8;
        font-size = 32;
        ignore-empty-password = true;

        text-color = c "text";
        text-ver-color = c "text";
        text-wrong-color = c "text";
        text-clear-color = c "text";

        inside-color = "${c "base"}99";
        inside-ver-color = "${c "base"}99";
        inside-wrong-color = "${c "base"}99";
        inside-clear-color = "${c "base"}99";

        ring-color = "${c "muted"}66";
        ring-ver-color = c "accent";
        ring-wrong-color = c "danger";
        ring-clear-color = c "muted";

        key-hl-color = c "accent";
        bs-hl-color = c "danger";
        line-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        line-clear-color = "00000000";
        separator-color = "00000000";
      };
    };

    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command = lock;
        }
        {
          timeout = 600;
          command = "${swaymsg} 'output * power off'";
          resumeCommand = "${swaymsg} 'output * power on'";
        }
      ];
      events = {
        before-sleep = lock;
        # `loginctl lock-session` (the keybind) goes through here
        lock = lock;
      };
    };
  };
}
