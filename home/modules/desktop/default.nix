{pkgs, ...}: {
  imports = [
    ./programs.nix
  ];

  home.packages = with pkgs; [
    swayfx
    autotiling-rs # open new windows in the direction with most space
    waybar
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

  programs.alacritty = {
    enable = true;
    theme = "gruvbox_dark";
    settings = {
      window.padding = {
        x = 20;
        y = 20;
      };
      font = {
        size = 15;
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
      };
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
      "sway/config".source = ./sway/sway.conf;
      "waybar/config".source = ./sway/waybar/waybar.conf;
      "waybar/style.css".source = ./sway/waybar/style.css;
      "keylist/config.yaml".source = ./sway/waybar/keybinds.yaml;
      "sway/mullvad-check.sh" = {
        source = ./sway/waybar/mullvad-check.sh;
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
