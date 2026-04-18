{
  inputs,
  pkgs,
  ...
}:
{
  boot = {
    plymouth = {
      enable = true;
      theme = "ello";
      themePackages = [
        inputs.ello-plymouth.packages.${pkgs.system}.default
      ];
    };

    # silent boot
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      # prevent the kernel from blanking plymouth out of the fb
      "fbcon=nodefer"
      # disable boot logo if any
      "logo.nologo"
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
    # hide OS choice. Can still be opened by pressing any key
    loader.timeout = 0;
  };
}
