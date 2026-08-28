{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
in {
  flake.modules.nixos.walker = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.mikoshi.walker;
  in {
    options.mikoshi.walker = {
      enable = lib.mkEnableOption "Walker launcher";
    };
    config = lib.mkIf cfg.enable {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.walker;

      environment.systemPackages = with pkgs; [
        walker
        elephant
      ];

      # elephant must run inside the user session, not as a system service —
      # it silently breaks without the session's environment variables
      systemd.user.services.elephant = {
        description = "Elephant launcher backend";
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        bindsTo = ["graphical-session.target"];
        serviceConfig.ExecStart = "${pkgs.elephant}/bin/elephant";
      };
    };
  };

  flake.modules.homeManager.walker = {...}: {
    config = {
      xdg.configFile."walker/config.toml".text = ''
        [providers]
        default = ["desktopapplications"]
        empty = ["desktopapplications"]

        [[providers.prefixes]]
        prefix = "="
        provider = "calc"

        [[providers.prefixes]]
        prefix = "/"
        provider = "files"

        [[providers.prefixes]]
        prefix = ":"
        provider = "clipboard"
      '';

      # providers load automatically when installed; keep only the ones walker
      # uses (desktopapplications, calc, files, clipboard) plus menus and
      # providerlist, which walker's action system relies on internally
      xdg.configFile."elephant/elephant.toml".text = ''
        ignored_providers = [
          "1password",
          "archlinuxpkgs",
          "bitwarden",
          "bluetooth",
          "bookmarks",
          "dnfpackages",
          "niriactions",
          "nirisessions",
          "playerctl",
          "runner",
          "snippets",
          "symbols",
          "todo",
          "unicode",
          "websearch",
          "windows",
          "wireplumber",
        ]
      '';
    };
  };
}
