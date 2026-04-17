{
  mkImports,
  username,
  pkgs,
  ...
}:
{
  imports = mkImports ../../system [
    /desktop.nix
    /firejail.nix
    /vpn.nix
    /gaming.nix
    /boot.nix
    /services/glance
    /services/forgejo.nix
    /services/beszel.nix
  ];

  home-manager.users.${username}.imports = mkImports ../../home [
    /desktop
    /cli
    /cli/tools.nix
    /editors/zed.nix
    /browser/brave.nix
    /apps
    /apps/minecraft
    /apps/music.nix
    /browser/zen.nix
    /ai
    /editors/helix.nix
  ];

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
