{...}: {
  flake.modules.nixos.base = {
    lib,
    pkgs,
    ...
  }: {
    options.mikoshi = {
      meta = {
        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "Users to configure via home-manager on this host";
        };
        keyboardLayouts = lib.mkOption {
          default = ["gb"];
          type = lib.types.listOf lib.types.str;
          description = "the keyboard layouts to set";
        };
      };
      gnome = {
        mainMod = lib.mkOption {
          default = "Alt";
          type = lib.types.str;
          description = "Modifier key to use for keybindings (GSettings format, e.g. Alt, Super, Control)";
        };
      };

      plasma = {
        mainMod = lib.mkOption {
          default = "Alt";
          type = lib.types.str;
          description = "Modifier key to use for keybindings (GSettings format, e.g. Alt, Super, Control)";
        };
      };

      hyprland = {
        monitors = lib.mkOption {
          default = [",preferred,auto,auto"];
          type = lib.types.listOf lib.types.str;
          description = "A list of Hyprland monitor configurations (format: 'name,resolution,position,scale')";
        };

        wallpaper = lib.mkOption {
          default = null;
          type = lib.types.nullOr lib.types.path;
          description = "Path to wallpaper image file";
        };

        kb = lib.mkOption {
          default = "gb";
          type = lib.types.str;
          description = "Keyboard layout to use";
        };

        kbOptions = lib.mkOption {
          default = "ctrl:nocaps,grp:win_space_toggle";
          type = lib.types.str;
          description = "XKB keyboard options (e.g. 'ctrl:nocaps,grp:win_space_toggle')";
        };

        launcherKeybind = lib.mkOption {
          default = "SUPER, SUPER_L";
          type = lib.types.str;
          description = "The keybind for launching wofi";
        };

        mainMod = lib.mkOption {
          default = "ALT";
          type = lib.types.str;
          description = "the button to use as mainMod";
        };

        terminal = lib.mkOption {
          default = pkgs.ghostty;
          type = lib.types.package;
          description = "Package to use as the default terminal";
        };

        fileManager = lib.mkOption {
          default = pkgs.nautilus;
          type = lib.types.package;
          description = "Package to use as the default file manager";
        };
      };
    };
  };
}
