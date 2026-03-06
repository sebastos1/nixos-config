{...}: {
  imports = [
    ./modules/cli
  ];
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.11";
}
