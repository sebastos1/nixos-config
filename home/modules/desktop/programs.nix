{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brave
    nautilus
    mpv
    oculante # images
  ];
}
