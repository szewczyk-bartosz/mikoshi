{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
  gtkColors = config.flake.lib.gtkColors;
in {
  flake.modules.nixos.appearance = {
    config,
    pkgs,
    lib,
    ...
  }: {
    options.mikoshi.appearance.enable = lib.mkEnableOption "GTK, Qt, icon, cursor and font theming";

    config = lib.mkIf config.mikoshi.appearance.enable {
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.appearance;

      fonts.packages = [pkgs.nunito];
      # above fonts.nix's mkDefault, below a plain host value
      fonts.fontconfig.defaultFonts.sansSerif = lib.mkOverride 900 ["Nunito"];

      # home-manager writes color-scheme, icon and cursor settings through dconf
      programs.dconf.enable = true;

      programs.thunar.enable = true;
      services.tumbler.enable = true;
      services.gvfs.enable = true;
    };
  };

  flake.modules.homeManager.appearance = {
    pkgs,
    osConfig,
    ...
  }: let
    polarity = osConfig.mikoshi.theme.polarity;
    palette = (import ./_palette.nix).${polarity};
    iconTheme = "WhiteSur-${polarity}";
    qtctSettings = {
      Appearance = {
        style = "kvantum";
        icon_theme = iconTheme;
      };
      Fonts.general = ''"Nunito,11"'';
    };
    # adw-gtk3 and libadwaita both read these named colours; layering matches
    # the greeter: base backdrop and fields, overlay cards, subtle borders
    adwaitaColors =
      gtkColors palette
      + ''
        @define-color accent_color @accent;
        @define-color accent_bg_color @accent;
        @define-color accent_fg_color @base;
        @define-color theme_selected_bg_color @accent;
        @define-color theme_selected_fg_color @base;
        @define-color window_bg_color @base;
        @define-color window_fg_color @text;
        @define-color view_bg_color @base;
        @define-color view_fg_color @text;
        @define-color headerbar_bg_color @surface;
        @define-color headerbar_fg_color @text;
        @define-color headerbar_backdrop_color @base;
        @define-color sidebar_bg_color @surface;
        @define-color sidebar_fg_color @text;
        @define-color card_bg_color @overlay;
        @define-color card_fg_color @text;
        @define-color popover_bg_color @overlay;
        @define-color popover_fg_color @text;
        @define-color dialog_bg_color @overlay;
        @define-color dialog_fg_color @text;
        @define-color borders @subtle;
        @define-color destructive_color @danger;
        @define-color destructive_bg_color @danger;
        @define-color destructive_fg_color @base;
        @define-color error_color @danger;
        @define-color warning_color @warning;
      '';
  in {
    home.pointerCursor = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
      size = 24;
      gtk.enable = true;
      # XCURSOR_THEME / XCURSOR_SIZE for Xwayland clients
      x11.enable = true;
    };

    gtk = {
      enable = true;
      colorScheme = polarity;
      font = {
        name = "Nunito";
        size = 11;
      };
      theme = {
        name =
          if polarity == "dark"
          then "adw-gtk3-dark"
          else "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = iconTheme;
        package = pkgs.whitesur-icon-theme;
      };
      gtk3.extraCss = adwaitaColors;
      # keep libadwaita's own stylesheet, only recolour it
      gtk4.theme = null;
      gtk4.extraCss = adwaitaColors;
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
      kvantum = {
        enable = true;
        themes = [pkgs.whitesur-kde];
        settings.General.theme =
          if polarity == "dark"
          then "WhiteSurDark"
          else "WhiteSur";
      };
      qt5ctSettings = qtctSettings;
      qt6ctSettings = qtctSettings;
    };
  };
}
