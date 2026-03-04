{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/term.nix
  ];

  home.packages = with pkgs; [
    lnav
    lazydocker
  ];

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };


  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
