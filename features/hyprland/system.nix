{
  config,
  lib,
  pkgs,
  ...
}: let
  daemon = pkgs.writers.writePython3Bin "hyprland-alt-tab-daemon" {} ''
    import socket
    import os
    import sys


    def get_socket_path():
        sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
        if not sig:
            sys.exit(1)
        runtime_dir = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
        return f"{runtime_dir}/hypr/{sig}/.socket2.sock"


    def main():
        state_file = os.path.expanduser("~/.cache/hypr-altworkspace")
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        sock.connect(get_socket_path())
        current = "1"
        with open(state_file, "w") as f:
            f.write("1")
        buf = ""
        while True:
            buf += sock.recv(4096).decode("utf-8", errors="ignore")
            while "\n" in buf:
                line, buf = buf.split("\n", 1)
                if line.startswith("workspace>>"):
                    new = line.split(">>")[1].strip()
                    if new != current:
                        with open(state_file, "w") as f:
                            f.write(current)
                        current = new


    main()
  '';
  switcher = pkgs.writeShellScriptBin "hyprland-alt-tab" ''
    prev=$(cat ~/.cache/hypr-altworkspace 2>/dev/null || echo "1")
    hyprctl dispatch workspace "$prev"
  '';
in {
  imports = [./options.nix];
  config = lib.mkIf config.mikoshi.hyprland.enable {
    programs.hyprland.enable = true;
    home-manager = {
      sharedModules = [./home.nix ./waybar.nix];
    };
    # Not sure how I feel about this, this might be lighter but I think I prefer the look of the gnome one
    # services.greetd = {
    #   enable = true;
    #   settings = {
    #     default_session = {
    #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
    #       user = "greeter";
    #     };
    #   };
    # };

    systemd.user.services.swayosd-server = {
      description = "SwayOSD Server";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      serviceConfig.ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
    };
    console = {
      font = lib.mkDefault "Lat2-Terminus16";
      useXkbConfig = lib.mkDefault true;
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      daemon
      switcher
      wofi
      playerctl
      pavucontrol
      wlogout
      brightnessctl
      waybar
      swaynotificationcenter
      networkmanagerapplet
      lxqt.lxqt-policykit
      grimblast
      nautilus
      swayosd
    ];

    xdg.portal = {
      enable = true;
      config.common.default = "*";
    };
  };
}
