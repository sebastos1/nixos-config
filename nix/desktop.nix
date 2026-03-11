{
  pkgs,
  username,
  ...
}: {
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  nix.settings.trusted-users = [username];
  security = {
    sudo.extraConfig = "Defaults pwfeedback"; # show asterisks
    sudo.wheelNeedsPassword = false;
  };
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.swayfx}/bin/sway --unsupported-gpu";
        user = username;
      };
      default_session = initial_session;
    };
  };
  # nixpkgs.config.chromium.enableWideVine = true;

  fonts.fontconfig = {
    enable = true;
    # antialiasing = true;
    # hinting = "slight";
    # subpixelRendering = "rgb";
    useEmbeddedBitmaps = true; # needed for emojis
  };

  # audio
  security.rtkit.enable = true;
  services.pipewire.enable = true;
}
