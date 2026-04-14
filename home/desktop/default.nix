{
  pkgs,
  lib,
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

    # pws
    bitwarden-desktop
    rbw

    adwaita-icon-theme
    swaybg
    nautilus
    mpv
    # oculante # images
  ];

  programs.tofi = {
    enable = true;
    settings = {
      font-size = lib.mkForce "25";
      num-results = 10;
      result-spacing = 25;
      width = "100%";
      height = "100%";
      padding-top = "15%";
      padding-left = "35%";
      padding-right = "35%";
      outline-width = 0;
      border-width = 0;
    };
  };

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
