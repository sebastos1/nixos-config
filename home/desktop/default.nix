{pkgs, ...}: {
  imports = [
    ./waybar
    ./rofi
    ./niri
  ];

  home.packages = with pkgs; [
    wl-clipboard # copy/paste
    sway-contrib.grimshot

    fuzzel

    # pws
    bitwarden-desktop
    rbw

    nautilus
    mpv
    oculante # images
  ];

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 20;
    gtk.enable = true;
    sway.enable = true;
  };
}
