{
  inputs,
  pkgs,
  ...
}: {
  boot = {
    plymouth = {
      enable = true;
      theme = "ello";
      themePackages = [inputs.ello-plymouth.packages.${pkgs.system}.default];
    };

    # silent boot
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "nvidia-drm.fbdev=1"
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"

      # show only errors or worse in udev
      "rd.udev.log_level=3"
    ];
    # hide OS choice. Can still be opened by pressing any key
    loader.timeout = 0;
  };
}
