{...}: {
  flake.homeManagerModules.hyprland = {
    osConfig,
    lib,
    ...
  }: let
    workspaces = builtins.genList (x: x) 10;
  in {
    config = lib.mkIf osConfig.mikoshi.hyprland.enable {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          "$mainMod" = osConfig.mikoshi.hyprland.mainMod;
          bind =
            [
              "$mainMod, Return, exec, kitty"
              "$mainMod SHIFT, Q, killactive"
              "$mainMod SHIFT, O, exit"
              "$mainMod, H, movefocus, l"
              "$mainMod, J, movefocus, d"
              "$mainMod, K, movefocus, u"
              "$mainMod, L, movefocus, r"
              "$mainMod SHIFT, H, movewindow, l"
              "$mainMod SHIFT, J, movewindow, d"
              "$mainMod SHIFT, K, movewindow, u"
              "$mainMod SHIFT, L, movewindow, r"
              "$mainMod, V, togglefloating"
              # Omarchy inspired
              "SUPER, C, sendshortcut, CTRL, Insert"
              "SUPER, V, sendshortcut, SHIFT, Insert"
            ]
            ++ (map (i: "$mainMod, ${toString i}, workspace, ${toString i}") workspaces)
            ++ (map (i: "$mainMod, ${toString i}, movetoworkspace, ${toString i}") workspaces);

          input = {
            follow_mouse = 1;
            kb_layout = osConfig.mikoshi.hyprland.keyboardLayout;
          };
          monitor = osConfig.mikoshi.hyprland.monitors;
        };
      };
    };
  };
}
