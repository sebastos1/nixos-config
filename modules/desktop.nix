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
    htop

    # font
    nerd-fonts.meslo-lg
  ];

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
    ".config/i3/config".source = ../i3/config;
    ".config/i3status-rust/config.toml".source = ../i3/status.toml;
    ".config/i3status-rust/mullvad-check.sh" = {
      source = ../i3/mullvad-check.sh;
      executable = true;
    };
  };
}
