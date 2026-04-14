{
  lib,
  pkgs,
  ...
}:
{
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

  dconf.settings = lib.mkForce { };
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

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "26.05";
}
