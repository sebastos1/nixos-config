{
  pkgs,
  username,
  ...
}: {
  security.polkit.enable = true;
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
  nix.settings.trusted-users = [username];
  services.gnome.gnome-keyring.enable = true;
  security = {
    sudo.extraConfig = "Defaults pwfeedback"; # show asterisks
    sudo.wheelNeedsPassword = false;
  };

  # nixpkgs.config.chromium.enableWideVine = true;
}
