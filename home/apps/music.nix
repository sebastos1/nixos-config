{pkgs, ...}: {
  home.packages = with pkgs; [
    mpc
    # nicotine-plus
  ];

  services.mpd = {
    enable = true;
    musicDirectory = "~/music";
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

  programs.rmpc = {
    enable = true;
    # todo https://nix-community.github.io/home-manager/options.xhtml#opt-programs.rmpc.config
  };

  # programs.ncmpcpp = {
  #   enable = true;
  #   package = pkgs.ncmpcpp.override { visualizerSupport = true; };
  #   settings = {
  #     # sick visualizer
  #     visualizer_data_source = "/tmp/mpd.fifo";
  #     visualizer_output_name = "Visualizer";
  #     visualizer_in_stereo = "yes";
  #     visualizer_type = "wave";
  #     visualizer_look = "●●";
  #     visualizer_color = "blue, green, yellow, magenta, red";
  #     visualizer_spectrum_smooth_look = "yes";
  #     volume_change_step = 10;
  #     user_interface = "alternative";
  #     progressbar_look = "━━";
  #   };
  # };
}
