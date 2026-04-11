{
  pkgs,
  ...
}:
{
  imports = [
    ./niri
    ./ironbar
  ];

  home.packages = with pkgs; [
    cliphist
    wl-clipboard # copy/paste

    fuzzel

    # pws
    bitwarden-desktop
    rbw

    adwaita-icon-theme

    nautilus
    mpv
    # oculante # images

    swaybg
  ];

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 20;
    gtk.enable = true;
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 120;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];
  };
}
