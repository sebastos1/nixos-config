{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rofi
    i3status-rust
    arandr
    dunst
    networkmanagerapplet
    alttab
    i3wsr

    htop
    xclip

    # font
    font-awesome
    nerd-fonts.meslo-lg
  ];

  home.pointerCursor = {
    name = "material_light_cursors";
    package = pkgs.material-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    settings = {
      unredir-if-possible = true;
      use-damage = true;
    };
  };

  # ig this can be here
  programs.kitty = {
    enable = true;
    themeFile = "GruvboxMaterialDarkHard";
    font = {
      name = "MesloLGSDZ Nerd Font Mono";
      size = 12;
    };
    settings = {
      scrollback_lines = 10000;
      window_padding_width = "6";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      sync_to_monitor = true;
    };
    shellIntegration.enableFishIntegration = true;
  };

  home.file = {
    ".config/i3/config".source = ../i3/i3config;
    ".config/rofi/config.rasi".source = ../i3/rofi.rasi;
    ".config/i3status-rust/config.toml".source = ../i3/i3status-rust.toml;
    ".config/i3status-rust/mullvad-check.sh" = { source = ../i3/mullvad-check.sh; executable = true; };
    ".config/i3wsr/config.toml".source = ../i3/wsr.toml;
  };
}
