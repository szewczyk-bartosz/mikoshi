{
  osConfig,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.hyprshell.homeModules.hyprshell];
  config = lib.mkIf osConfig.mikoshi.hyprland.enable {
    programs.hyprshell = {
      enable = true;
      systemd.enable = true;
      settings = {
        windows = {
          enable = true;
          switch = {
            enable = true;
            modifier = "alt";
          };
          overview = {
            enable = true;
            key = "super_l";
            launcher = {
              max_items = 6;
            };
          };
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = osConfig.mikoshi.hyprland.mainMod;
        "$terminal" = lib.getExe osConfig.mikoshi.hyprland.terminal;
        "$fileManager" = lib.getExe osConfig.mikoshi.hyprland.fileManager;

        monitor = osConfig.mikoshi.hyprland.monitors;

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "NIXOS_OZONE_WL,1"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
        ];

        "exec-once" = [
          "lxqt-polkit"
          "waybar"
          "swaync"
          "nm-applet"
        ];

        input = {
          kb_layout = osConfig.mikoshi.hyprland.keyboardLayout;
          kb_options = "ctrl:nocaps";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;
          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];
          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 0, 1.94, almostLinear, fade"
            "workspacesIn, 0, 1.21, almostLinear, fade"
            "workspacesOut, 0, 1.94, almostLinear, fade"
          ];
        };

        dwindle = {
          pseudotile = false;
          preserve_split = true;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };

        bind = [
          # core
          "$mainMod, RETURN, exec, $terminal"
          "$mainMod SHIFT, Q, killactive"
          "$mainMod SHIFT, O, exit"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating"
          # focus
          "$mainMod, H, movefocus, l"
          "$mainMod, J, movefocus, d"
          "$mainMod, K, movefocus, u"
          "$mainMod, L, movefocus, r"
          # move window
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, J, movewindow, d"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, L, movewindow, r"
          # workspaces
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
          "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
          "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
          "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
          "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
          "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
          "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
          "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
          "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
          "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
        ];

        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl play-pause"
        ];
      };
    };
  };
}
