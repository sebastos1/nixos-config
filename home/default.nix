{ ... }:
{
  imports = [
    ./theme.nix
  ];

  theme.enable = true;

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "26.05";
}
