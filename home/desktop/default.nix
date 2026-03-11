{pkgs, ...}: {
  imports = [
    ./waybar
    ./rofi
  ];

  home.packages = with pkgs; [
    wl-clipboard # copy/paste
    sway-contrib.grimshot

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
