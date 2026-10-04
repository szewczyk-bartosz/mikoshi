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
    cfg = config.mikoshi.wm.sway;
    altTabDaemon = pkgs.writers.writePython3Bin "mikoshiAltTabDaemon" {libraries = [pkgs.python3Packages.i3ipc];} ''
    import i3ipc
    import os
    import subprocess

    ipc = i3ipc.Connection()

    state_file = os.path.expanduser("~/.cache/mikoshi-alttabworkspace")
    os.makedirs(os.path.dirname(state_file), exist_ok=True)

    with open(state_file, "w") as f:
        f.write("1:1")


    def on_output(ipc, event):
        focused = [i for i in ipc.get_workspaces() if i.focused]
        if focused:
            n = focused[0].name.partition(":")[0]
            binpath = "${mikoshiWorkspaceSwitcher}/bin/msw"
            subprocess.run([binpath, n])


    def on_workspace(ipc, event):
        if event.change == 'focus' and event.old:
            old = event.old.name  # the workspace you just left
            new = event.current.name
            # extract N from "N:j"
            prev_n = old.partition(":")[0]
            new_n = new.partition(":")[0]
            if prev_n != new_n:
                with open(state_file, "w") as f:
                    f.write(old)


    ipc.on("workspace", on_workspace)
    ipc.on("output", on_output)
    ipc.main()
    '';
    mikoshiAltTab = pkgs.writeShellApplication {
      name = "mikoshiAltTab";
      runtimeInputs = [ mikoshiWorkspaceSwitcher ];
      text = ''
      prev=$(cat ~/.cache/mikoshi-alttabworkspace)
      N=$(echo "$prev" | cut -d: -f1)
      j=$(echo "$prev" | cut -d: -f2)
      msw "$N" "$j"
        '';
    };
    # active outputs ordered left to right, top to bottom; output j of desktop N is this list's j-th line
    mswOutputs = pkgs.writeShellScriptBin "msw-outputs" ''
      swaymsg -t get_outputs | jq -r '[.[] | select(.active)] | sort_by(.rect.x, .rect.y) | .[].name'
    '';
    mswMove = pkgs.writeShellScriptBin "msw-move" ''
      N=$1
      focused=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
      j=$(${mswOutputs}/bin/msw-outputs | grep -nxF "$focused" | cut -d: -f1)
      swaymsg "move container to workspace $N:$j"
    '';
    mikoshiWorkspaceSwitcher = pkgs.writeShellScriptBin "msw" ''
      N=$1
      focus_index=''${2:-}
      original=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
      monitors=$(${mswOutputs}/bin/msw-outputs)
      count=$(echo "$monitors" | wc -l)

      # Move orphaned windows
      swaymsg -t get_workspaces | jq -r --arg n "$N" '.[].name | select(startswith($n + ":"))' |
      while IFS= read -r ws; do
          j=''${ws#*:}
          if [ "$j" -gt "$count" ]; then
              swaymsg "[workspace=\"^$ws\$\"] move container to workspace $N:$count"
          fi
      done
      
      # Create workspace layout
      j=1
      focus_output=""
      while IFS= read -r monitor; do
          swaymsg "focus output $monitor; workspace $N:$j; move workspace to output $monitor"
          if [ "$j" = "$focus_index" ]; then
              focus_output=$monitor
          fi
          j=$((j + 1))
      done <<< "$monitors"

      if [ -n "$focus_output" ]; then
          swaymsg "focus output $focus_output"
      else
          swaymsg "focus output $original"
      fi
    '';
  in {
    options.mikoshi.wm.sway = {
      enable = lib.mkEnableOption "Sway desktop";
    };
    config = lib.mkIf cfg.enable {
      # mikoshi.walker.enable = lib.mkDefault true;
      mikoshi.waybar.enable = lib.mkDefault true;
      mikoshi.swaync.enable = lib.mkDefault true;
      mikoshi.graphical.enable = lib.mkDefault true;
      # home-manager.users = hmFor config.mikoshi.meta.users hmClass.sway;

      programs.sway = {
        enable = true;
        package = pkgs.swayfx;
        extraSessionCommands = ''
          export WLR_SCENE_DISABLE_DIRECT_SCANOUT=1
        '';
      };

      programs.uwsm = {
        enable = true;
        waylandCompositors.sway = {
          prettyName = "Sway";
          comment = "Sway compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/sway";
        };
      };

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd \"uwsm start sway\"";
            user = "greeter";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        foot
        jq
        swayidle
        playerctl
        grimblast
        fuzzel
        mikoshiWorkspaceSwitcher
        mswMove
        mikoshiAltTab
        swayosd
        lxqt.lxqt-policykit
      ];

      home-manager.users = hmFor config.mikoshi.meta.users {
        systemd.user.services.mikoshiAltTabDaemon = {
          Unit = {
            Description = "Mikoshi alt-tab workspace tracker";
            After = ["graphical-session.target"];
            PartOf = ["graphical-session.target"];
          };
          Service = {
            ExecStart = "${altTabDaemon}/bin/mikoshiAltTabDaemon";
            Restart = "on-failure";
            RestartSec = "5s";
          };
          Install.WantedBy = ["graphical-session.target"];
        };
      };

      systemd.user.services.swayosd-server = {
        description = "SwayOSD Server";
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
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
    cfg = osConfig.mikoshi.wm.sway;
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
