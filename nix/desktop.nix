{
  pkgs,
  username,
  ...
}:
{
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  programs.niri = {
    enable = true;
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      user = "greeter";
    };
  };

  nix.settings.trusted-users = [ username ];
  security = {
    sudo.extraConfig = "Defaults pwfeedback"; # show asterisks
    sudo.wheelNeedsPassword = false;
  };

  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };

  fonts.enableDefaultPackages = false;
  fonts.fontconfig = {
    enable = true;
    useEmbeddedBitmaps = true; # needed for emojis
  };

  # audio
  security.rtkit.enable = true;
  services.pipewire.enable = true;
}
