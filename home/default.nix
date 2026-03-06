{
  ...
}:
{
  imports = [
    ./modules/term.nix
  ];
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.11";
}
