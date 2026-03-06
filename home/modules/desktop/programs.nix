{pkgs, ...}: {
  home.packages = with pkgs; [
    nautilus
    mpv
    oculante # images
  ];
}
