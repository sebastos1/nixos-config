{pkgs, ...}: {
  home.packages = with pkgs; [
    mangohud
    wineWow64Packages.stable
    winetricks
    protonup-qt
    protontricks
    lutris
    heroic

    osu-lazer-bin

    # (blender.override { cudaSupport = true; })
  ];

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {cudaSupport = true;};
  };

  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;
    config = {
      useQuickCss = false;
      themeLinks = [
        "https://raw.githubusercontent.com/shvedes/discord-gruvbox/refs/heads/main/gruvbox-dark.theme.css"
      ];
      plugins = {
        volumeBooster = {
          enable = true;
          multiplier = 2.0;
        };
        noTypingAnimation.enable = true;
        consoleJanitor.enable = true;
        # noTrack.enable = true;
        # clearURLs.enable = true;
        anonymiseFileNames.enable = true;
        noDevtoolsWarning.enable = true;
        silentTyping.enable = true;
        # noDeepLinks.enable = true;
        noSystemBadge.enable = true;
        # noRpc.enable = true;
        noMosaic.enable = true;
        noPendingCount.enable = true;
        noOnboardingDelay.enable = true;
        betterSettings.enable = true;
        gameActivityToggle.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}
