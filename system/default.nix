{
  pkgs,
  keylist,
  username,
  inputs,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      keylist.overlays.default
      (final: prev: {
        ironbar = inputs.ironbar.packages.${prev.system}.default;
      })
    ];
  };

  nix = {
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
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # remove defaults
  services.xserver.desktopManager.xterm.enable = false;
  environment = {
    defaultPackages = [];
    systemPackages = with pkgs; [
      wget
    ];
  };

  # networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = false;
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = false;
    "net.ipv6.conf.all.forwarding" = false;
    "net.ipv4.conf.all.send_requests" = false;
    "net.ipv4.conf.all.accept_redirects" = false;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
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
}
