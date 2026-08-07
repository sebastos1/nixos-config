{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelModules = [
      "kvm-amd"
    ];
    extraModulePackages = [ ];
    initrd = {
      kernelModules = [ "amdgpu" ];
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
      ];
    };
    kernel = {
      # for zram
      sysctl = {
        "vm.swappiness" = 10;
        "vm.page-cluster" = 0;
      };
      sysfs.kernel.mm.transparent_hugepage = {
        enabled = "madvise";
        defrag = "defer+madvise";
      };
    };
  };

  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
      priority = 0; # last resort
    }
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e8c5251b-d52b-400b-8a75-0870d734b868";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D175-0D13";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # hardware.amdgpu.overdrive.enable = true;
  # services.lact.enable = true;

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
