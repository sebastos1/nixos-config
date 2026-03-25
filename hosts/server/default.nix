{ ... }:
{
  imports = [
    ./hardware.nix
    ./services/homepage.nix
    ./services/matrix.nix
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
        ingress = {
          # "ssh.shlb.ng" = "ssh://localhost:22";
          # "dash.shlb.ng" = "http://localhost:3033";
          # # "sjallabong.com" = "http://localhost:3000";
          # "pool.sjallabong.com" = "http://localhost:8080";
          # "account.sjallabong.com" = "http://localhost:3001";

          # "matrix.sjallabong.com" = "http://localhost:6167";
          # "sjallabong.com" = {
          #   service = "http://localhost:6167"; # /.well-known
          #   path = "/.well-known/matrix/.*";
          # };
          # # "sjallabong.com" = "cinny";
        };
        default = "http_status:404";
      };
    };
  };

  system.stateVersion = "25.11";
}
