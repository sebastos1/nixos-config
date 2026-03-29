{
  mkImports,
  config,
  pkgs,
  ...
}: let
  imports = [
    /desktop.nix
    /firejail.nix
    /vpn.nix
    # /docker.nix
    /gaming.nix
    /boot.nix
  ];
in {
  networking.hostName = "CarPlay_9814";

  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  # hardware specific
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # mobo doesnt support the apic pstate control that gamemode uses
    kernelModules = ["acpi-cpufreq"];
    kernelParams = [
      "initcall_blacklist=amd_pstate_init"
      "intel_pstate=disable"
      "video=1920x1080"

      # testing. not much value
      "nmi_watchdog=0"
      "pcie_aspm.policy=performance"
      # "mitigations=off"
      "threadirqs"
      "processor.max_cstate=1"
    ];

    kernel = {
      # for zram
      sysctl = {
        "vm.swappiness" = 100;
        "vm.page-cluster" = 0;
      };
      sysfs.kernel.mm.transparent_hugepage = {
        enabled = "madvise";
        defrag = "defer+madvise";
      };
      # if pstate
      # sysfs.devices.system.cpu."cpu[0-9]*".energy_performance_preference = "performance";
    };
  };

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
  powerManagement.cpuFreqGovernor = "performance";

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
  };

  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
      priority = 0; # last resort
    }
  ];

  imports =
    [
      ./hardware.nix
      ../server/services/glance
    ]
    ++ mkImports ../../system imports;

  system.stateVersion = "25.05";
}
