{ pkgs, username, ... }:
{
  imports = [
    ./firejail.nix
  ];

  nixpkgs.config.chromium.enableWideVine = true;
  users.users.${username}.packages = with pkgs; [
    brave
  ];
}
