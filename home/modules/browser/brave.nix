{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    ];
  };

  # manually set file icon since firejail gobbles it up *nom nom*
  home.file.".local/share/icons/hicolor/16x16/apps/brave.png".source = "${pkgs.brave}/share/icons/hicolor/16x16/apps/brave-browser.png";
  home.file.".local/share/icons/hicolor/24x24/apps/brave.png".source = "${pkgs.brave}/share/icons/hicolor/24x24/apps/brave-browser.png";
  home.file.".local/share/icons/hicolor/32x32/apps/brave.png".source = "${pkgs.brave}/share/icons/hicolor/32x32/apps/brave-browser.png";
  home.file.".local/share/icons/hicolor/48x48/apps/brave.png".source = "${pkgs.brave}/share/icons/hicolor/48x48/apps/brave-browser.png";
  home.file.".local/share/icons/hicolor/64x64/apps/brave.png".source = "${pkgs.brave}/share/icons/hicolor/64x64/apps/brave-browser.png";
  home.file.".local/share/icons/hicolor/128x128/apps/brave.png".source = "${pkgs.brave}/share/icons/hicolor/128x128/apps/brave-browser.png";
  home.file.".local/share/icons/hicolor/256x256/apps/brave.png".source = "${pkgs.brave}/share/icons/hicolor/256x256/apps/brave-browser.png";
}
