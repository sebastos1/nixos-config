{ mkImports, username, ... }:
{
  networking.hostName = "Mozart";

  imports = [
    ./hardware.nix
  ]
  ++ mkImports ../../system [
    /desktop.nix
    /firejail.nix
    /vpn.nix
    /boot.nix
  ];

  home-manager.users.${username} = {
    imports = mkImports ../../home [
      /desktop
      /cli
      /cli/tools.nix
      /editors/zed.nix
      /browser/brave.nix
    ];
  };

  system.stateVersion = "25.05";
}
