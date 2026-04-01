{
  pkgs,
  username,
  keylist,
  inputs,
  ...
}:
{
  # TODO TODO TODO TODO TODO TODO TODO TODO

  nixpkgs.overlays = [
    keylist.overlays.default
    (final: prev: {
      ironbar = inputs.ironbar.packages.${prev.system}.default;
    })
  ];

  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
      user = "greeter";
    };
  };

  # https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  nix.settings = {
    substituters = [ "https://cache.garnix.io" ];
    trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  };

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  users.users.${username}.extraGroups = [
    "networkmanager"
  ];

  services.xserver = {
    xkb = {
      layout = "no";
      variant = "nodeadkeys";
    };
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    touchpad.accelProfile = "flat";
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # highly recommended apparently
  environment.systemPackages = with pkgs; [
    xwayland-satellite # xwayland support
  ];

  nix.settings.trusted-users = [ username ];
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
