{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ironbar
    pavucontrol
  ];

  home.file = {
    ".config/ironbar/config.corn".source = ./config.corn;
    ".config/ironbar/style.css".source = ./style.css;
    ".config/ironbar/mully.sh".source = ./mully.sh;
  };
}
