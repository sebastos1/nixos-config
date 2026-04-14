{
  pkgs,
  username,
  inputs,
  ...
}:
{
  imports = [
    ./ironbar
  ];

  hjem.users.${username} = {
    files = {
      ".config/niri/config.kdl".source = ./niri.kdl;
      ".config/foot/foot.ini".source = ./foot.ini;
      ".config/tofi/config".text = ''
        font-size = 25
        num-results = 10
        result-spacing = 25
        width = 100%
        height = 100%
        padding-top = 15%
        padding-left = 35%
        padding-right = 35%
        outline-width = 0
        border-width = 0
      '';
    };
  };

  users.users.${username} = {
    packages = with pkgs; [
      cliphist
      wl-clipboard # copy/paste

      adwaita-icon-theme
      swaybg

      nautilus

      # pws
      bitwarden-desktop
      rbw

      bibata-cursors

      foot

    ];
    extraGroups = [
      "networkmanager"
    ];
  };

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "20";
  };

  systemd.user.services.swayidle = {
    description = "swayidle";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle -w \
          timeout 120 "${pkgs.niri}/bin/niri msg action power-off-monitors" \
            resume "${pkgs.niri}/bin/niri msg action power-on-monitors"
      '';
      Restart = "on-failure";
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      ironbar = inputs.ironbar.packages.${prev.system}.default;
    })
  ];

  programs.niri.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
      user = "greeter";
    };
  };

  # https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  services.xserver = {
    xkb = {
      layout = "no";
      variant = "nodeadkeys";
    };
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    touchpad.accelProfile = "flat";
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # highly recommended apparently
  environment.systemPackages = with pkgs; [
    xwayland-satellite # xwayland support
  ];

  nix.settings.trusted-users = [ username ];

  nixpkgs.config.chromium.enableWideVine = true;

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      font-awesome
      noto-fonts # latin, greek, cyrillic, etc
      noto-fonts-cjk-sans # chinese, japanese, korean
      twitter-color-emoji
      nerd-fonts.jetbrains-mono
      ibm-plex
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      useEmbeddedBitmaps = true; # for emojis
      subpixel = {
        rgba = "none";
        lcdfilter = "none";
      };
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
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };

  stylix = {
    enable = true;
    overlays.enable = false;
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
      };
    };
    # targets.zen-browser.profileNames = [ "default" ];
  };

  # audio
  security.rtkit.enable = true;
  services.pipewire.enable = true;
}
