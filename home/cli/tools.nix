{pkgs, ...}: {
  home.packages = with pkgs; [
    ouch # zips
    p7zip # zip
    ffmpeg # video
    zathura # pdf
    imagemagick # image biz
    jq # json
    resvg # svg
    glow # markdown

    pastel

    # cargo new and such
    cargo
    cloudflared
  ];

  programs.fish.shellAliases = {
    unzip = "ouch decompress";
  };

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
