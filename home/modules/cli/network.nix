{pkgs, ...}: {
  home.packages = with pkgs; [
    curlie
    nmap
    dog
  ];
}
