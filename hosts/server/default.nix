{ ... }:
{
  imports = [
    ./hardware.nix
    ../../nix/homepage.nix
  ];

  networking = {
    hostName = "Diorite";
    domain = "local";
    firewall.allowedTCPPorts = [
      22
      80
      443
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  services.fail2ban.enable = true;

  # stay alive
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
      dns = [
        "192.168.1.1"
        "1.1.1.1"
        "8.8.8.8"
      ];
      ipv6 = false;
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "67f421c8-1836-4702-82c6-304741c443ac" = {
        credentialsFile = "/etc/cloudflared/tunnel.json";
        default = "http_status:404";
        ingress = {
          "ssh.shlb.ng" = "ssh://localhost:22";
          "dash.shlb.ng" = "http://localhost:3033";
          "sjallabong.com" = "http://localhost:3000";
          "pool.sjallabong.com" = "http://localhost:8080";
          "account.sjallabong.com" = "http://localhost:3001";
        };
      };
    };
  };

  system.stateVersion = "25.11";
}
