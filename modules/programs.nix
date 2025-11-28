{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    brave
    ungoogled-chromium # no vpn on this one
    osu-lazer-bin
    prismlauncher
    jdk21
    mangohud

    # music
    mpc
    nicotine-plus
  ];

  xdg.desktopEntries.chromium-novpn = {
    name = "Chromium (no vpn, ungoogled)";
    exec = "mullvad-exclude chromium";
    icon = "chromium";
  };

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override { cudaSupport = true; };
  };

  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
    network.startWhenNeeded = true;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire"
        mixer_type "software"
      }
      audio_output {
        type "fifo"
        name "Visualizer"
        path "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';
  };
  services.mpd-discord-rpc.enable = true;

  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    settings = {
      # sick visualizer
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "Visualizer";
      visualizer_in_stereo = "yes";
      visualizer_type = "wave";
      visualizer_look = "●●";
      visualizer_color = "blue, green, yellow, magenta, red";
      visualizer_spectrum_smooth_look = "yes";
      volume_change_step = 10;
      user_interface = "alternative";
      progressbar_look = "━━";
    };
  };

  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;
    config = {
      useQuickCss = false;
      themeLinks = ["https://raw.githubusercontent.com/shvedes/discord-gruvbox/refs/heads/main/gruvbox-dark.theme.css"];
      plugins = {
        noTypingAnimation.enable = true;
        consoleJanitor.enable = true;
        # noTrack.enable = true;
        clearURLs.enable = true;
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
