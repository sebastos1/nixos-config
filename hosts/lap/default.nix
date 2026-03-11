{...}: {
  imports = [
    ./hardware.nix
    ../../nix/desktop.nix
    ../../nix/firejail.nix
    ../../nix/vpn.nix
  ];

  networking.hostName = "Mozart";

  services.libinput.enable = true;

  system.stateVersion = "25.05";
}
