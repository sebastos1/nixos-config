{ mkImports, username, ... }:
{
  networking.hostName = "Mozart";

  imports = mkImports ../../system [
    /client
    /firejail.nix
    /vpn.nix
  ];

  home-manager.users.${username} = {
    imports = mkImports ../../home [
      /desktop
      /cli
      /cli/tools.nix
      /editor/zed.nix
      /browser/brave.nix
    ];
    theme = {
      light = true;
      name = "gruvbox-material-light-hard";
      fonts.sizes.terminal = 10;
    };
  };

  system.stateVersion = "25.05";
}
