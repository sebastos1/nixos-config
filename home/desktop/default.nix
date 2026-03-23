{ inputs, pkgs, ... }:
{
  imports = [
    ./niri
    ./ironbar
  ];

  home.packages = with pkgs; [
    wl-clipboard # copy/paste
    sway-contrib.grimshot

    fuzzel

    # pws
    bitwarden-desktop
    rbw

    adwaita-icon-theme

    nautilus
    mpv
    oculante # images

    swaybg

  ];

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 20;
    gtk.enable = true;
    sway.enable = true;
  };
}
