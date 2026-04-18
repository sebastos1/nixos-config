{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./boot.nix
  ];

  programs.niri.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

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

  nixpkgs.config.chromium.enableWideVine = true;

  fonts = {
    enableDefaultPackages = false;
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true; # for emojis
      subpixel = {
        rgba = "none";
        lcdfilter = "none";
      };
    };
  };

  # audio
  security.rtkit.enable = true;
  services.pipewire.enable = true;
}
