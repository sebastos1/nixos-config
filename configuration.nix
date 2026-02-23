{
  config, pkgs, lib, nix-gaming, keylist, ...
}: {
  imports = [
    ./hardware-configuration.nix
    "${nix-gaming}/modules/pipewireLowLatency.nix"
    "${nix-gaming}/modules/platformOptimizations.nix"
  ];

  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # old ahh motherboard doesnt support the modern apic pstate control, used by gamemode
    kernelModules = [ "acpi-cpufreq" ];
    kernelParams = [
      "initcall_blacklist=amd_pstate_init"
      "intel_pstate=disable"
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
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
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  # networking
  services.mullvad-vpn.enable = true;
  networking = {
    hostName = "CarPlay_9814";
    networkmanager.enable = true;
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

  # audio
  security.rtkit.enable = true;
  services.pipewire.enable = true;

  users.users.seb = {
    isNormalUser = true;
    description = "seb";
    extraGroups = ["networkmanager" "wheel" "input" "openrazer"];
  };

  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  security.sudo.extraConfig = "Defaults pwfeedback"; # show asterisks when typing sudo password
  services.gnome.gnome-keyring.enable = true;
  nix.settings.trusted-users = [ "seb" ];
  security.sudo.wheelNeedsPassword = false;

  # wayland (sway)
  security.polkit.enable = true;
  #services.xserver.enable = true;
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.swayfx}/bin/sway --unsupported-gpu";
        user = "seb";
      };
      default_session = initial_session;
    };
  };

  # by me
  nixpkgs.overlays = [ keylist.overlays.default ];

  nixpkgs.config.chromium.enableWideVine = true;
  hardware.openrazer.enable = true;
  environment.systemPackages = with pkgs; [
    wget
    openrazer-daemon # razer sucks never buy
  ];

  # services.input-remapper.enable = true; # map keyboard buttons fast
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    platformOptimizations.enable = true;
    protontricks.enable = true;
    gamescopeSession.enable = false;
    #remotePlay.openFirewall = true;
    #dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [
      python3 # used by elden ring
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +7d";
  };

  system.stateVersion = "25.05";
}
