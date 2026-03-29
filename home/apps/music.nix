{ pkgs, ... }:
{
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
  # services.mpd-discord-rpc.enable = true;

  programs.rmpc = {
    enable = true;
    # todo https://nix-community.github.io/home-manager/options.xhtml#opt-programs.rmpc.config
  };
}
