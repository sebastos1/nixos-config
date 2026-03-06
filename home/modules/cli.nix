{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ouch # zips
    p7zip # zip
    ffmpeg # video
    poppler # pdf
    imagemagick # image biz
    jq # json
    resvg # svg
    glow # markdown

    pastel

    # cargo new and such
    cargo
    cloudflared
  ];

  # tui files
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    plugins = with pkgs.yaziPlugins; {
      inherit
        git
        mediainfo
        duckdb
        ;
    };
    shellWrapperName = "y";
  };
}
