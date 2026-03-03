{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/cli.nix
    ../modules/desktop
    ../modules/editors/zed.nix
    ../modules/browser/brave.nix
    ../modules/apps
  ];
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
