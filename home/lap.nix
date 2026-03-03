{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/desktop
    ./modules/term.nix
    ./modules/dev.nix
  ];
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
