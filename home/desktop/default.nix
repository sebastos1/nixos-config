{ pkgs, ... }:
{
  imports = [
    ./waybar
    ./terminal.nix
  ];

  home.packages = with pkgs; [
    swayfx
    autotiling-rs # open new windows in the direction with most space
    keylist

    sway-contrib.grimshot
    wl-clipboard # copy/paste

    # pws
    bitwarden-desktop
    rbw

    # rofi additions
    rofi-rbw-wayland
    pinentry-curses
    rofimoji # emoji

    # fonts
    font-awesome
    noto-fonts # latin, greek, cyrillic, etc
    noto-fonts-cjk-sans # chinese, japanese, korean

    nautilus
    mpv
    oculante # images
  ];

  programs.rofi = {
    enable = true;
    plugins = with pkgs; [
      rofi-calc
    ];
    modes = [
      "drun"
      "calc"
      "emoji:rofimoji"
    ];
    extraConfig = {
      display-drun = "drun";
      display-calc = "calc";
      display-emoji = "emoji";
      show-icons = true;
    };
    # theme = ./sway/rofi.rasi;
  };

  xdg = {
    configFile = {
      "sway/config".source = ./sway/sway.conf;
      "waybar/config".source = ./waybar/waybar.conf;
      "keylist/config.yaml".source = ./waybar/keybinds.yaml;
      "sway/mullvad-check.sh" = {
        source = ./waybar/mullvad-check.sh;
        executable = true;
      };
      "rofi-rbw.rc".text = ''
        no-folder=true
        action=type
        target=password
      '';
    };
  };

  home.pointerCursor = {
    name = "material_light_cursors";
    package = pkgs.material-cursors;
    size = 24;
    gtk.enable = true;
    sway.enable = true;
  };
}
