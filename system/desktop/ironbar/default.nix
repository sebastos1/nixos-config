{ pkgs, username, ... }:
{

  users.users.${username}.packages = with pkgs; [
    ironbar
    pavucontrol
  ];

  hjem.users.${username}.files = {
    ".config/ironbar/config.corn".source = ./config.corn;
    ".config/ironbar/style.css".source = ./style.css;
    ".config/ironbar/mully.sh".source = ./mully.sh;
  };
}
