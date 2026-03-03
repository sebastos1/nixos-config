{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-config.nix];

  networking = {
    hostName = "Diorite";
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443];
    };
  };

  users.users.dio = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services = {
    # avahi.enable = false;
    fail2ban.enable = true;
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = false;
    "net.ipv6.conf.all.forwarding" = false;
    "net.ipv4.conf.all.send_requests" = false;
    "net.ipv4.conf.all.accept_redirects" = false;
  };

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

  # trackpad
  services.libinput.enable = true;

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
          "sjallabong.com" = "http://localhost:3000";
          "pool.sjallabong.com" = "http://localhost:8080";
          "account.sjallabong.com" = "http://localhost:3001";
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

  system.stateVersion = "25.11";
}
