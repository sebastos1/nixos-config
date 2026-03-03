{pkgs, ...}: {
  home.packages = with pkgs; [
    brave
    nautilus
    mpv
    imv
  ];

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "Gruvbox Material";
      window-padding-x = 12;
      window-padding-y = 12;
      window-padding-balance = true;
    };
  };
}
