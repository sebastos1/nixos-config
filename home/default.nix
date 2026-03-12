{
  lib,
  pkgs,
  ...
}: {
  # goat terminal
  programs.alacritty = {
    enable = true;
    settings = {
      window.padding = {
        x = 20;
        y = 20;
      };
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

  dconf.settings = lib.mkForce {};
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
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
        terminal = 12;
        applications = 12;
        # popups
        # desktop
      };
    };
    targets.waybar.enable = false;
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
    subpixelRendering = "rgb";
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
  home.stateVersion = "25.11";
}
