{pkgs, ...}: {
  home.packages = with pkgs; [
    ouch # zips
    ffmpeg # video
    poppler # pdf
    imagemagick # image biz
    p7zip # zip
    jq # json
    resvg # svg
    glow # markdown

    pastel
    xcolor

    # cargo new and such
    cargo
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
