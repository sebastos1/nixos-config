{pkgs, ...}: {
  home.packages = with pkgs; [
    rofi-rbw-wayland
    pinentry-curses
    rofimoji # emoji
  ];

  # todo this thing sucks
  programs.rofi = {
    enable = true;
    plugins = with pkgs; [
      rofi-calc
    ];
    modes = [
      "drun"
      "calc"
      "emoji:rofimoji"
    ];
    extraConfig = {
      display-drun = "drun";
      display-calc = "calc";
      display-emoji = "emoji";
      show-icons = true;
    };
    # theme = ./sway/rofi.rasi;
  };

  xdg = {
    configFile = {
      "rofi-rbw.rc".text = ''
        no-folder=true
        action=type
        target=password
      '';
    };
  };
}
