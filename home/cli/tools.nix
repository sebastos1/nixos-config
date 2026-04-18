{ pkgs, ... }:
{
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
    keymap.mgr.prepend_keymap = [
      {
        on = [ "i" ];
        run = "arrow -1";
        desc = "Move up";
      }
      {
        on = [ "k" ];
        run = "arrow 1";
        desc = "Move down";
      }
      {
        on = [ "j" ];
        run = "leave";
        desc = "Go to parent";
      }
      {
        on = [ "l" ];
        run = "enter";
        desc = "Enter directory";
      }
    ];
  };
}
