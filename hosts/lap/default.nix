{ mkImports, username, ... }:
{
  networking.hostName = "Mozart";

  imports = mkImports ../../system [
    /client
    /firejail.nix
    /vpn.nix
  ];

  home-manager.users.${username}.imports = mkImports ../../home [
    /desktop
    /cli
    /cli/tools.nix
    /editor/zed.nix
    /browser/brave.nix
  ];

  system.stateVersion = "25.05";
}
