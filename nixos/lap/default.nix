{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-config.nix
    ../firejail.nix
  ];

  networking.hostName = "Mozart";

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore"; # closing lid doesn't put to sleep
    HandleSuspendKey = "ignore";
    HandleHibernateKey = "ignore";
  };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  security.polkit.enable = true;
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

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.seb = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = false;
    "net.ipv6.conf.all.forwarding" = false;
    "net.ipv4.conf.all.send_requests" = false;
    "net.ipv4.conf.all.accept_redirects" = false;
  };

  system.stateVersion = "25.05";
}
