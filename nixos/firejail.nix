{ pkgs, ... }: {
  programs.firejail = {
    enable = true;
    wrappedBinaries.brave = {
      executable = "${pkgs.brave}/bin/brave";
      profile = "${pkgs.firejail}/etc/firejail/brave.profile";
      desktop = "${pkgs.brave}/share/applications/brave-browser.desktop";
    };
  };
}
