{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./niri
  ];

  theme.client = true;

  home.packages = with pkgs; [
    cliphist
    wl-clipboard # copy/paste

    # pws
    bitwarden-desktop
    rbw

    adwaita-icon-theme
    swaybg
    nautilus
    mpv
    # oculante # images
  ];

  programs.fish.shellAliases = {
    copy = "wl-copy"; # copy < file.txt
  };

  programs.tofi = {
    enable = true;
    settings = {
      font-size = lib.mkForce "25";
      num-results = 10;
      result-spacing = 25;
      width = "100%";
      height = "100%";
      padding-top = "15%";
      padding-left = "35%";
      padding-right = "35%";
      outline-width = 0;
      border-width = 0;
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 120;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];
  };

  services.wlsunset = {
    enable = true;
    temperature = {
      night = 4500;
    };
    sunrise = "05:00";
    sunset = "21:00";
  };

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        dpi-aware = lib.mkForce "yes";
        pad = "10x10";
      };
      scrollback = {
        lines = 10000;
        multiplier = 5.0;
      };
      cursor = {
        blink = "yes";
        style = "beam";
      };
      mouse.hide-when-typing = "yes";
      # colors-dark = { # todo: wait for blur :)
      #   alpha = lib.mkForce "0.9";
      #   blur = "yes"; # coming to niri soon I heard
      # };
      desktop-notifications.inhibit-when-focused = "yes";
    };
  };

  xdg.userDirs = {
    enable = true;
    music = "$HOME/music/";
    pictures = "$HOME/pics/";
    videos = "$HOME/vids/";
    documents = "$HOME/other/";
    download = "$HOME/other/";
    desktop = "$HOME/other/";
    publicShare = "$HOME/other/";
    templates = "$HOME/other/";
  };
}
