{
  config,
  pkgs,
  keylist,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      keylist.overlays.default # by me
    ];
  };

  nix.settings = {
    warn-dirty = false;
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["seb"];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # locale
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
  };
  services.xserver.xkb = {
    layout = "no";
    variant = "nodeadkeys";
  };
  console.keyMap = "no";

  # networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  # audio
  security.rtkit.enable = true;
  services.pipewire.enable = true;

  users.users.seb = {
    isNormalUser = true;
    description = "seb";
    extraGroups = ["networkmanager" "wheel" "input"];
  };

  security.sudo.extraConfig = "Defaults pwfeedback"; # show asterisks when typing sudo password
  services.gnome.gnome-keyring.enable = true;
  security.sudo.wheelNeedsPassword = false;
  security.protectKernelImage = true;

  # remove defaults
  services.xserver.desktopManager.xterm.enable = false;
  environment.defaultPackages = [];
  environment.systemPackages = with pkgs; [
    wget
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +7d";
  };

  system.stateVersion = "25.05";
}
