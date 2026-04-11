{ pkgs, ... }:
{
  home.packages = with pkgs; [
    curlie
    nmap
    doggo
    arp-scan
  ];
}
