{
  pkgs,
  username,
  ...
}: {
  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      user = "greeter";
    };
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # highly recommended apparently
  environment.systemPackages = with pkgs; [
    xwayland-satellite # xwayland support
  ];

  nix.settings.trusted-users = [username];
  security = {
    sudo.extraConfig = "Defaults pwfeedback"; # show asterisks
    sudo.wheelNeedsPassword = false;
  };

  nixpkgs.config.chromium.enableWideVine = true;

  fonts.enableDefaultPackages = false;
  fonts.fontconfig = {
    enable = true;
    useEmbeddedBitmaps = true; # needed for emojis
  };

  # audio
  security.rtkit.enable = true;
  services.pipewire.enable = true;
}
