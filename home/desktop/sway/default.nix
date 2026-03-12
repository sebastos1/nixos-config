{pkgs, ...}: {
  home.packages = with pkgs; [
    swaysome
    autotiling-rs # open new windows in the direction with most space
    swayest-workstyle
    gcr
  ];

  services.gnome-keyring.enable = true;

  xdg.configFile."sworkstyle/config.toml".text = ''
    separator = "  "

    [matching]
    "brave-browser" = ""
    "dev.zed.Zed" = ""
    "steam" = ""
  '';

  wayland.windowManager.sway = let
    mod = "Mod4";
  in {
    enable = true;
    package = pkgs.swayfx;
    # systemd.variables = [ "--all" ];
    checkConfig = false;
    # wrapperFeatures.gtk = true;
    config = {
      bars = []; # disable swaybar
      floating.modifier = mod;
      up = "i";
      keybindings = {
        "${mod}+Shift+w" = "kill";
        "${mod}+Shift+c" = "reload";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        # externals
        "${mod}+Return" = "exec alacritty";
        "${mod}+d" = "exec rofi -show drun";
        "${mod}+p" = "exec rofi-rbw --selector-args='-theme-str \"window { width: 900px; }\"'";
        "${mod}+s" = "exec grimshot copy screen";
        "${mod}+Shift+s" = "exec grimshot copy area";
      };
      startup = [
        {command = "exec autotiling-rs";}
        {command = "sworkstyle &> /tmp/sworkstyle.log";}
        {command = "waybar";}
      ];
      input."*" = {
        xkb_layout = "no";
        xkb_variant = "nodeadkeys";
        accel_profile = "flat";
        middle_emulation = "disabled";
      };
      output = {
        "DP-3" = {
          resolution = "1920x1200";
          position = "0,0";
        };
        "DP-2" = {
          resolution = "1920x1080";
          position = "1920,0";
        };
        "HDMI-A-1" = {
          resolution = "1680x1050";
          position = "3840,0";
        };
      };
    };
    extraConfig = builtins.readFile ./sway.conf;
  };
}
