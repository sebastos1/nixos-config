{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    lnav
    lazydocker
  ];

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };
}
