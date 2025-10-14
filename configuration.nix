{
  config,
  pkgs,
  lib,
  nix-gaming,
  ...
}: {
  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };

  imports = [
    ./hardware-configuration.nix
    "${nix-gaming}/modules/pipewireLowLatency.nix"
    "${nix-gaming}/modules/platformOptimizations.nix"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    platformOptimizations.enable = true;
    protontricks.enable = true;
    gamescopeSession.enable = false;
    #remotePlay.openFirewall = true;
    #dedicatedServer.openFirewall = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    #forceFullCompositionPipeline = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    nvidiaSettings = true;
    open = false;
  };
  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    VKD3D_CONFIG = "dxr";
    PROTON_ENABLE_NGX_UPDATER = "1";
    PROTON_ENABLE_NVAPI = "1";
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  users.users.seb = {
    isNormalUser = true;
    description = "seb";
    extraGroups = ["networkmanager" "wheel" "input" "openrazer"];
  };
  services.getty.autologinUser = "seb";

  # networking
  services.mullvad-vpn.enable = true;
  networking = {
    hostName = "sebus";
    networkmanager.enable = true;
    # firewall = {
    #   enable = true;
    #   allowedTCPPorts = [ 22 80 443 ];
    #   allowedUDPPorts = [ 51820 ];
    # }
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

  # i3
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --mode 1680x1050 --pos 3840x0 --rotate normal --output DP-0 --off --output DP-1 --off --output DP-2 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-3 --off --output DP-4 --mode 1920x1200 --pos 0x0 --rotate normal --output DP-5 --off
    '';
  };
  services.displayManager = {
    defaultSession = "none+i3";
    autoLogin = {
      enable = true;
      user = "seb";
    };
  };
  # for auto login
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.chromium.enableWideVine = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    unzip
    zip
    file
    killall
    # piper
    protonup-qt
    protontricks
    #wine64
    #wine
    #lutris
    nix-your-shell

    # razer (FUCK YOUUUUUUUUUUUUUUUU)
    openrazer-daemon
    polychromatic
  ];

  hardware.openrazer.enable = true;

  # audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    lowLatency.enable = true;
    #jack.enable = true;
  };

  # mouse
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
    };
  };
  # services.ratbagd.enable = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  system.stateVersion = "25.05";
}
