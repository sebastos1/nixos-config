{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    i3wsr

    htop
    xclip

    # pws
    bitwarden-desktop
    rbw
    rofi-rbw-x11
    pinentry-curses
    xdotool

    sway
    waybar
    # wofi
    yad
    rofi
    rofi-calc
    ghostty

    # font
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.roboto-mono
    nerd-fonts.meslo-lg


    wl-clipboard # copy/paste
  ];

  home.pointerCursor = {
    name = "material_light_cursors";
    package = pkgs.material-cursors;
    size = 24;
    gtk.enable = true;
    sway.enable = true;
  };

  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    hinting = "slight";
    subpixelRendering = "rgb";
  };

  home.file = {
    ".config/sway/config".source = ../sway/config;
    ".config/waybar/config".source = ../sway/waybar/config;
    ".config/waybar/style.css".source = ../sway/waybar/style.css;
    ".config/sway/mullvad-check.sh" = { source = ../sway/mullvad-check.sh; executable = true; };
    ".config/rofi/config.rasi".source = ../sway/rofi/config.rasi;
    ".config/rofi/style.rasi".source = ../sway/rofi/style.rasi;
  };
}
