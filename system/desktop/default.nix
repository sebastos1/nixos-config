{
  pkgs,
  username,
  inputs,
  theme,
  ...
}:
{
  imports = [
    ./ironbar
    ./boot.nix
  ];

  hjem.users.${username} = {
    files = {
      ".config/niri/config.kdl".source = ./niri.kdl;
      ".config/foot/foot.ini".text = ''
        [main]
        term=foot
        dpi-aware=yes
        pad=10x10
        font=${theme.font} Mono:size=16, Noto Color Emoji:size=16

        [scrollback]
        lines=10000
        multiplier=5.0

        [cursor]
        blink=yes
        style=beam

        [mouse]
        hide-when-typing=yes

        [desktop-notifications]
        inhibit-when-focused=yes

        [colors]
        background=${theme.term.bg}
        foreground=${theme.term.fg}
        regular0=${theme.term.black}
        regular1=${theme.term.red}
        regular2=${theme.term.green}
        regular3=${theme.term.yellow}
        regular4=${theme.term.blue}
        regular5=${theme.term.magenta}
        regular6=${theme.term.cyan}
        regular7=${theme.term.white}
        bright0=${theme.term.bright-black}
        bright1=${theme.term.bright-red}
        bright2=${theme.term.bright-green}
        bright3=${theme.term.bright-yellow}
        bright4=${theme.term.bright-blue}
        bright5=${theme.term.bright-magenta}
        bright6=${theme.term.bright-cyan}
        bright7=${theme.term.bright-white}
      '';
      ".config/tofi/config".text = ''
        font = ${theme.font}
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
        background-color = ${theme.bg}ff
        text-color = ${theme.fg}ff
        selection-color = ${theme.blue}ff
        selection-background = ${theme.bg}00
        prompt-color = ${theme.pink}ff
      '';
    };
  };

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

  users.users.${username} = {
    packages = with pkgs; [
      foot
      tofi
      swaybg
      nautilus
      bibata-cursors
      adwaita-icon-theme

      cliphist
      wl-clipboard # copy/paste

      # pws
      bitwarden-desktop
      rbw
    ];
    extraGroups = [
      "networkmanager"
    ];
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

  # audio
  security.rtkit.enable = true;
  services.pipewire.enable = true;
}
