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

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = ["192.168.1.1" "1.1.1.1" "8.8.8.8"];
      ipv6 = false;
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "ec27b1d3-eae0-464a-a76f-a1bd9a16426a" = {
        credentialsFile = "/etc/cloudflared/tunnel.json";
        default = "http_status:404";
        ingress = {
          "shlb.ng" = "http://localhost:3000";
          "sjallabong.eu" = "http://localhost:3000";
          "pool.sjallabong.eu" = "http://localhost:8080";
          "auth.sjallabong.eu" = "http://localhost:3001";
        };
      };
    };
  };

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.seb = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
  };

  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     PasswordAuthentication = false; # todo?
  #     PermitRootLogin = "no";
  #    };
  # };

  services = {
    avahi.enable = false;
    fail2ban.enable = true;
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = false;
    "net.ipv6.conf.all.forwarding" = false;
    "net.ipv4.conf.all.send_requests" = false;
    "net.ipv4.conf.all.accept_redirects" = false;
  };

  system.stateVersion = "25.05";
}
