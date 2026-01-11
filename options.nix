lib: {
  theme = lib.mkOption {
    default = "akasara";
    type = lib.types.str;
    description = "the theme that Mikoshi will use currently not implemented"; # TODO: Implement themes
  };
  monitor = lib.mkOption {
    default = ",preferred,auto,auto";
    type = lib.types.str;
    description = "Hyprland monitor configuration (format: 'name,resolution,position,scale')";
  };

  keyboardLayout = lib.mkOption {
    default = "gb";
    type = lib.types.str;
    description = "Keyboard layout to use";
  };
}
