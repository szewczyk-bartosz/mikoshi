{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
in {
  flake.modules.nixos.thunar = {
    config,
    lib,
    ...
  }: let
    cfg = config.mikoshi.thunar;
  in {
    options.mikoshi.thunar = {
      enable = lib.mkEnableOption "Thunar file manager with thumbnails and gvfs";

      terminalAction = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Manage Thunar's custom actions (uca.xml) so "Open Terminal Here" opens
          ghostty in the selected folder. The stock action relies on exo-open, which
          isn't installed. Turning this on makes uca.xml read-only, so custom actions
          can't be added from Thunar's GUI; set it to false to manage that file yourself.
        '';
      };
    };

    config = lib.mkIf cfg.enable {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.thunar;

      programs.thunar.enable = true;
      services.tumbler.enable = true;
      services.gvfs.enable = true;
    };
  };

  flake.modules.homeManager.thunar = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    # the default action shells out to exo-open, which we don't ship
    xdg.configFile."Thunar/uca.xml" = lib.mkIf osConfig.mikoshi.thunar.terminalAction {
      force = true; # replaces the file Thunar generated on first run
      text = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <actions>
        <action>
        	<icon>utilities-terminal</icon>
        	<name>Open Terminal Here</name>
        	<unique-id>mikoshi-open-terminal</unique-id>
        	<command>${lib.getExe pkgs.ghostty} --working-directory=%f</command>
        	<description>Open a terminal in this folder</description>
        	<patterns>*</patterns>
        	<startup-notify/>
        	<directories/>
        </action>
        </actions>
      '';
    };
  };
}
