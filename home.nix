{
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "25.05";
  imports = [
    ./modules/desktop.nix
    ./modules/shell.nix
    ./modules/dev.nix
    ./modules/programs.nix
  ];
}
