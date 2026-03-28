{mkImports, ...}: let
  imports = [
    /desktop.nix
    /firejail.nix
    /vpn.nix
    /boot.nix
  ];
in {
  networking.hostName = "Mozart";

  imports =
    [
      ./hardware.nix
    ]
    ++ mkImports ../../system imports;

  system.stateVersion = "25.05";
}
