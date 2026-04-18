{
  lib,
  pkgs,
  ...
}:
let
  # everforest-dark-hard, everforest-dark-medium, onedark, gruvbox-dark-hard, gruvbox-material-dark-hard, solarized-dark
  # lights: gruvbox-light-medium, solarized-light
  # nice ones that arent in the base16 package below (found in the ghostty list):
  # ciapre, belafonte day, kanagawa lotus, havn skumring/daggry, everforest light med
  theme = "gruvbox-material-dark-hard";
in
{
  dconf.settings = lib.mkForce {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
    };
  };
  stylix = {
    enable = true;
    overlays.enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
    polarity = "dark";
    fonts = with pkgs; {
      monospace = {
        package = nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = ibm-plex;
        name = "IBM Plex Sans";
      };
      serif = {
        package = ibm-plex;
        name = "IBM Plex Serif";
      };
      emoji = {
        package = twitter-color-emoji;
        name = "Twitter Color Emoji";
      };
      sizes = {
        terminal = 14;
        applications = 12;
        desktop = 10;
      };
    };
    targets = {
      zen-browser.profileNames = [ "default" ];
    };
  };

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "26.05";
}
