{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    swayfx
    waybar
    # wofi
    yad
    rofi
    rofi-calc
    keylist

    # font
    font-awesome
    nerd-fonts.jetbrains-mono
    nerd-fonts.roboto-mono
    nerd-fonts.meslo-lg
    # maple?

    # imv, mpv


    i3wsr
    htop
    xclip

    # pws
    bitwarden-desktop
    rbw
    rofi-rbw-x11
    pinentry-curses
    xdotool

    # grim
    # slurp

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

  xdg.configFile = {
    "sway/config".source = ./sway/config;
    "waybar/config".source = ./sway/waybar/config;
    "waybar/style.css".source = ./sway/waybar/style.css;
    "keylist/config.yaml".source = ./sway/keybinds.yaml;
    "rofi/config.rasi".source = ./sway/rofi/config.rasi;
    "rofi/style.rasi".source = ./sway/rofi/style.rasi;
    "sway/mullvad-check.sh" = { source = ./sway/mullvad-check.sh; executable = true; };
  };
}
