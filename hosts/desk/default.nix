{
  mkImports,
  pkgs,
  ...
}:
let
  imports = [
    /cli
    /desktop
    /browser
    /editor

    /vpn.nix
    /gaming.nix

    /services/glance
    /services/forgejo.nix
    /services/beszel.nix
  ];
in
{
  imports = [
    ./hardware.nix
  ]
  ++ mkImports ../../system imports;

  networking.hostName = "CarPlay_9814";

  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # scheduler
  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
  };

  system.stateVersion = "25.05";
}
