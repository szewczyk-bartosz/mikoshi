{config, ...}: let
  hmFor = config.flake.lib.hmFor;
  hmClass = config.flake.modules.homeManager;
in {
  flake.modules.nixos.sway = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.mikoshi.sway;
  in {
    options.mikoshi.sway = {
      enable = lib.mkEnableOption "Sway desktop";
    };
    config = lib.mkIf cfg.enable {
      mikoshi.walker.enable = lib.mkDefault true;
      home-manager.users = hmFor config.mikoshi.meta.users hmClass.sway;

      environment.systemPackages = with pkgs; [
        foot
        kanshi
        swayidle
        playerctl
        grimblast
        swayosd
        lxqt.lxqt-policykit
      ];

      systemd.user.services.swayosd-server = {
        description = "SwayOSD Server";
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        serviceConfig.ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
      };
    };
  };

  flake.modules.homeManager.sway = {
    lib,
    pkgs,
    osConfig,
    ...
  }: let
    cfg = osConfig.mikoshi.sway;
  in {
    config = {
      wayland.windowManager.sway = {
        enable = true;
        # keep the raw extraConfig authoritative instead of home-manager's
        # generated defaults (which would re-add Mod4 bindings)
        config = null;
        extraConfig = ''
          # Alt for window management, matching hyprland's mainMod;
          # the launcher is a separate bare Super tap below
          set $mod Mod1

          # session utilities
          exec lxqt-polkit
          exec kanshi
          exec swayidle

          # launcher: bare Super tap, mirroring hyprland's "SUPER, SUPER_L"
          bindsym Super_L exec walker

          # core
          bindsym $mod+Return exec foot
          bindsym $mod+Shift+q kill
          bindsym $mod+v floating toggle
          bindsym $mod+Shift+r reload
          bindsym $mod+Shift+e exit

          # focus
          bindsym $mod+h focus left
          bindsym $mod+j focus down
          bindsym $mod+k focus up
          bindsym $mod+l focus right

          # move window
          bindsym $mod+Shift+h move left
          bindsym $mod+Shift+j move down
          bindsym $mod+Shift+k move up
          bindsym $mod+Shift+l move right

          # workspaces
          bindsym $mod+1 workspace number 1
          bindsym $mod+2 workspace number 2
          bindsym $mod+3 workspace number 3
          bindsym $mod+4 workspace number 4
          bindsym $mod+5 workspace number 5
          bindsym $mod+6 workspace number 6
          bindsym $mod+7 workspace number 7
          bindsym $mod+8 workspace number 8
          bindsym $mod+9 workspace number 9
          bindsym $mod+0 workspace number 10

          # move to workspace — unlike hyprland's movetoworkspacesilent this
          # also switches focus to the target workspace; sway has no silent
          # variant (swaywm/sway#1518)
          bindsym $mod+Shift+1 move container to workspace number 1
          bindsym $mod+Shift+2 move container to workspace number 2
          bindsym $mod+Shift+3 move container to workspace number 3
          bindsym $mod+Shift+4 move container to workspace number 4
          bindsym $mod+Shift+5 move container to workspace number 5
          bindsym $mod+Shift+6 move container to workspace number 6
          bindsym $mod+Shift+7 move container to workspace number 7
          bindsym $mod+Shift+8 move container to workspace number 8
          bindsym $mod+Shift+9 move container to workspace number 9
          bindsym $mod+Shift+0 move container to workspace number 10

          # modifier+left-drag moves, modifier+right-drag resizes floating windows
          floating_modifier $mod

          # screenshot
          bindsym $mod+Shift+s exec grimblast copysave area ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png

          # volume / brightness (swayosd)
          bindsym XF86AudioRaiseVolume exec swayosd-client --output-volume raise
          bindsym XF86AudioLowerVolume exec swayosd-client --output-volume lower
          bindsym XF86AudioMute exec swayosd-client --output-volume mute-toggle
          bindsym XF86AudioMicMute exec swayosd-client --input-volume mute-toggle
          bindsym XF86MonBrightnessUp exec swayosd-client --brightness raise
          bindsym XF86MonBrightnessDown exec swayosd-client --brightness lower

          # media keys
          bindsym XF86AudioNext exec playerctl next
          bindsym XF86AudioPrev exec playerctl previous
          bindsym XF86AudioPlay exec playerctl play-pause
          bindsym XF86AudioPause exec playerctl play-pause
        '';
      };
    };
  };
}
