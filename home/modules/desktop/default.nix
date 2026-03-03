{pkgs, ...}: {
  home.packages = with pkgs; [
    swayfx
    waybar
    keylist

    # pws
    bitwarden-desktop
    rbw
    rofi-rbw-wayland
    pinentry-curses

    # emoji
    rofimoji

    sway-contrib.grimshot

    wl-clipboard # copy/paste

    # fonts
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.roboto-mono
    nerd-fonts.meslo-lg

    noto-fonts # latin, greek, cyrillic, etc
    noto-fonts-cjk-sans # chinese, japanese, korean
    noto-fonts-color-emoji # emojis
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
    theme = ./sway/rofi.rasi;
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "Gruvbox Material";
      window-padding-x = 12;
      window-padding-y = 12;
      window-padding-balance = true;
    };
  };

  xdg = {
    userDirs = {
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

    configFile = {
      "sway/config".source = ./sway/sway.cfg;
      "waybar/config".source = ./sway/waybar/waybar.cfg;
      "waybar/style.css".source = ./sway/waybar/style.css;
      "keylist/config.yaml".source = ./sway/keybinds.yaml;
      "sway/mullvad-check.sh" = {
        source = ./sway/mullvad-check.sh;
        executable = true;
      };
      "rofi-rbw.rc".text = ''
        no-folder=true
        action=type
        target=password
      '';
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
      antialiasing = true;
      hinting = "slight";
      subpixelRendering = "rgb";
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
      };
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
