{...}: {
  imports = [
    ./hardware.nix
    ../../nix/sway.nix
    ../../nix/firejail.nix
    ../../nix/vpn.nix
  ];

  networking.hostName = "Mozart";

  services.libinput.enable = true;

  system.stateVersion = "25.05";
}
