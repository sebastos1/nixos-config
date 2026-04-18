{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    lnav
  ];

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };
}
