{config, ...}: {
  flake.modules.nixos.gnome = {
    pkgs,
    lib,
    ...
  }: {
    options.mikoshi.gnome = {
      mainMod = lib.mkOption {
        default = "Alt";
        type = lib.types.str;
        description = "Modifier key to use for keybindings (GSettings format, e.g. Alt, Super, Control)";
      };
    };

    imports = [config.flake.modules.nixos.graphical];
    config = {
      programs.dconf.enable = true;
      services.displayManager.gdm.enable = true;
      services.xserver.enable = true;
      services.desktopManager.gnome.enable = true;
      services.gnome.core-apps.enable = false;
      programs.seahorse.enable = true;
      programs.evince.enable = true;
      environment.systemPackages = with pkgs; [
        gsettings-desktop-schemas
        nautilus
        gnome-characters
        gnome-calculator
        gnomeExtensions.pop-shell
        loupe
      ];
    };
  };

  flake.modules.homeManager.gnome = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    config = {
      dconf.settings = {
        # Dark mode and normal scaling
        "org/gnome/desktop/interface" = {
          color-scheme = lib.mkDefault "prefer-dark";
        };

        "org/gnome/desktop/input-sources" = {
          sources = map (layout: lib.hm.gvariant.mkTuple ["xkb" layout]) osConfig.mikoshi.keyboardLayouts;
        };

        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-1 = ["<${osConfig.mikoshi.gnome.mainMod}>1"];
          switch-to-workspace-2 = ["<${osConfig.mikoshi.gnome.mainMod}>2"];
          switch-to-workspace-3 = ["<${osConfig.mikoshi.gnome.mainMod}>3"];
          switch-to-workspace-4 = ["<${osConfig.mikoshi.gnome.mainMod}>4"];
          switch-to-workspace-5 = ["<${osConfig.mikoshi.gnome.mainMod}>5"];
          switch-to-workspace-6 = ["<${osConfig.mikoshi.gnome.mainMod}>6"];
          switch-to-workspace-7 = ["<${osConfig.mikoshi.gnome.mainMod}>7"];
          switch-to-workspace-8 = ["<${osConfig.mikoshi.gnome.mainMod}>8"];
          switch-to-workspace-9 = ["<${osConfig.mikoshi.gnome.mainMod}>9"];

          move-to-workspace-1 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>1"];
          move-to-workspace-2 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>2"];
          move-to-workspace-3 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>3"];
          move-to-workspace-4 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>4"];
          move-to-workspace-5 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>5"];
          move-to-workspace-6 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>6"];
          move-to-workspace-7 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>7"];
          move-to-workspace-8 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>8"];
          move-to-workspace-9 = ["<${osConfig.mikoshi.gnome.mainMod}><Shift>9"];
        };
      };
    };
  };
}
