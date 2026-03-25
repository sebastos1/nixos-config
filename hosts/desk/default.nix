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
    /docker.nix
    /gaming.nix
  ];
in {
  # chills on 6167
  services.matrix-continuwuity = {
    enable = true;
    settings = {
      global = {
        server_name = "sjallabong.com";
        allow_registration = false;
        allow_encryption = true;
        allow_federation = true;
        trusted_servers = ["matrix.org"];

        well_known = {
          client = "https://matrix.sjallabong.com";
          server = "matrix.sjallabong.com:443";
        };
      };
    };
  };

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
    ];
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
  };

  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  imports =
    [
      ./hardware.nix
    ]
    ++ mkImports ../../system imports;

  system.stateVersion = "25.05";
}
