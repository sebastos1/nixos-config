{
  lib,
  pkgs,
  ...
}:
{
  services.wlsunset = {
    enable = true;
    temperature = {
      # day = 6500;
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
        term = "foot";
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

  dconf.settings = lib.mkForce {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
    };
  };
  stylix = {
    enable = true;
    overlays.enable = false;
    # everforest-dark-hard / medium
    # onedark
    # gruvbox-dark-hard / material-dark-hard
    # solarized-dark

    # lights ig
    # gruvbox-light-medium
    # solarized-light

    # ones that arent in the base16 package below:
    # ciapre
    # belafonte day
    # kanagawa lotus
    # havn skumring/daggry
    # everforest light med
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };
      serif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Serif";
      };
      emoji = {
        package = pkgs.twitter-color-emoji;
        name = "Twitter Color Emoji";
      };
      sizes = {
        terminal = 14;
        applications = 12;
        # popups
        # desktop
      };
    };
    targets = {
      zen-browser.profileNames = [ "default" ];
    };
  };

  home.packages = with pkgs; [
    font-awesome
    noto-fonts # latin, greek, cyrillic, etc
    noto-fonts-cjk-sans # chinese, japanese, korean
    twitter-color-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    hinting = "slight";
    subpixelRendering = "none";
    defaultFonts = {
      monospace = [
        "JetBrainsMono Nerd Font"
        "Noto Sans CJK JP"
        "Twitter Color Emoji"
      ];
      sansSerif = [
        "IBM Plex Sans"
        "Noto Sans CJK JP"
        "Twitter Color Emoji"
      ];
      serif = [
        "IBM Plex Serif"
        "Noto Serif CJK JP"
        "Twitter Color Emoji"
      ];
      emoji = [
        "Twitter Color Emoji"
      ];
    };
  };

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "26.05";
}
