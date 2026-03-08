{
  config,
  pkgs,
  nix-gaming,
  ...
}: {
  imports = [
    ./hardware.nix
    "${nix-gaming}/modules/pipewireLowLatency.nix"
    "${nix-gaming}/modules/platformOptimizations.nix"
    ../../nix/sway.nix
    ../../nix/firejail.nix
    ../../nix/docker.nix
    ../../nix/vpn.nix
  ];

  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };

  networking.hostName = "CarPlay_9814";

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # mobo doesnt support the apic pstate control that gamemode uses
    kernelModules = ["acpi-cpufreq"];
    kernelParams = [
      "initcall_blacklist=amd_pstate_init"
      "intel_pstate=disable"
    ];
  };

  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  # graphics
  hardware.graphics = {
    enable = true; # lets apps use the gpu
    enable32Bit = true;
  };
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
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  nixpkgs.config.chromium.enableWideVine = true;

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

  system.stateVersion = "25.05";
}
