{
  pkgs,
  username,
  ...
}:
{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts # latin, greek, cyrillic, etc
      noto-fonts-cjk-sans # chinese, japanese, korean
      twitter-color-emoji
    ];

    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true; # for emojis
      hinting = {
        enable = true;
        style = "full";
      };
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "Twitter Color Emoji"
        ];
        serif = [
          "Noto Serif"
          "Twitter Color Emoji"
        ];
        sansSerif = [
          "Noto Sans"
          "Twitter Color Emoji"
        ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };

}
