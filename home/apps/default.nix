{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mangohud
    wineWow64Packages.stable
    winetricks
    protonup-qt
    # lutris
    # heroic
    osu-lazer-bin
  ];

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override { cudaSupport = true; };
  };

  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop = {
      enable = true;
      useSystemVencord = false;
    };
    config = {
      disableMinSize = true;
      plugins = {
        volumeBooster = {
          enable = true;
          multiplier = 2.0;
        };
        betterSettings.enable = true;
        gameActivityToggle.enable = true;
        forceOwnerCrown.enable = true;
        friendsSince.enable = true;
        fullSearchContext.enable = true;
        platformIndicators.enable = true;
        messageClickActions.enable = true;
        messageLatency.enable = true;
        messageLogger.enable = true;
        previewMessage.enable = true;
        revealAllSpoilers.enable = true;
        roleColorEverywhere.enable = true;
        serverListIndicators.enable = true;
        showMeYourName.enable = true;
        spotifyCrack.enable = true;
        typingIndicator.enable = true;
        typingTweaks.enable = true;
        whoReacted.enable = true;
        userVoiceShow.enable = true;
        ClearURLs.enable = true;
        anonymiseFileNames.enable = true;
        fakeNitro = {
          enable = true;
          enableEmojiBypass = false;
          enableStickerBypass = false;
          enableStreamQualityBypass = true; # only using for this
        };
        webScreenShareFixes.enable = true;
        # == DISABLE USELESS
        customIdle = {
          enable = true;
          idleTimeout = 0.0; # never idle
        };
        newGuildSettings = {
          # mute servers by default >:)
          enable = true;
          messages = 2; # no message notifs
        };
        silentTyping.enable = true;
        noTypingAnimation.enable = true;
        consoleJanitor.enable = true;
        noDevtoolsWarning.enable = true;
        noF1.enable = true;
        noProfileThemes.enable = true;
        noReplyMention.enable = true;
        plainFolderIcon.enable = true;
        noSystemBadge.enable = true;
        noMosaic.enable = true;
        noPendingCount.enable = true;
        noOnboardingDelay.enable = true;
      };
    };
  };
}
