{
  pkgs,
  username,
  ...
}:
{
  # only fully core options
  nixpkgs.config.allowUnfree = true;
  nix = {
    channel.enable = false;
    settings = {
      warn-dirty = false;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than +7d";
    };
  };

  security.protectKernelImage = true;
  boot.tmp.cleanOnBoot = true;
  systemd.coredump.enable = false;

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  # remove defaults
  environment = {
    defaultPackages = [ ];
    systemPackages = with pkgs; [
      wget
    ];
  };

  # networking
  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
    };
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = false;
    "net.ipv6.conf.all.forwarding" = false;
    # "net.ipv4.conf.all.send_requests" = false;
    "net.ipv4.conf.all.accept_redirects" = false;
  };

  # users.mutableUsers = false;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };
  security = {
    sudo.extraConfig = "Defaults pwfeedback"; # show asterisks
    sudo.wheelNeedsPassword = false;
  };

  # locale
  time.timeZone = "Europe/Oslo";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "nb_NO.UTF-8";
      LC_NUMERIC = "nb_NO.UTF-8";
      LC_MONETARY = "nb_NO.UTF-8";
      LC_PAPER = "nb_NO.UTF-8";
      LC_MEASUREMENT = "nb_NO.UTF-8";
      LC_ADDRESS = "nb_NO.UTF-8";
      LC_TELEPHONE = "nb_NO.UTF-8";
      LC_NAME = "nb_NO.UTF-8";
    };
  };
  console.keyMap = "no-latin1";
}
