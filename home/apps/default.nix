{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wineWow64Packages.stable
    winetricks
    protonup-qt
    lutris
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
        # friendsSince.enable = true;
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
        # typingIndicator.enable = true;
        # typingTweaks.enable = true;
        whoReacted.enable = true;
        userVoiceShow.enable = true;
        clearUrls.enable = true;
        anonymiseFileNames.enable = true;
        # fakeNitro = { borken :(
        #   enable = true;
        #   enableEmojiBypass = false;
        #   enableStickerBypass = false;
        #   enableStreamQualityBypass = true; # only using for this
        # };
        webScreenShareFixes.enable = true;
        # == DISABLE USELESS
        # customIdle = {
        #   enable = true;
        #   idleTimeout = 0.0; # never idle
        # };
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

  programs.mangohud = {
    enable = true;
    settings = {
      ### GPU
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_mem_clock = true;
      gpu_power = true;
      gpu_power_limit = true;
      gpu_load_change = true;
      gpu_fan = true;

      ### CPU
      cpu_stats = true;
      cpu_temp = true;
      cpu_power = true;
      cpu_mhz = true;
      cpu_load_change = true;
      core_load = true;
      core_load_change = true;
      core_bars = true;

      ### IO
      # io_read = true;
      # io_write = true;

      ### Memory
      vram = true;
      ram = true;
      swap = true;

      ### Frames
      fps = true;
      fps_color_change = true;
      fps_value = "60,120";
      frametime = true;
      fps_metrics = "avg,0.01,0.001";
      throttling_status = true;
      throttling_status_graph = true;
      wine = true;
      frame_timing = true;
      frame_timing_detailed = true;
      # dynamic_frame_timing = true;
      # histogram = true;
      # graphs = "cpu_temp,gpu_temp";

      ### Info
      gamemode = true;
      show_fps_limit = true;
      resolution = true;
      present_mode = true;
      display_server = true;

      ### Network
      # network = "eth0,wlo1";
    };
  };
}
