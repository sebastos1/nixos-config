{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096;
    }
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    hostName = "pie";
    useDHCP = false;
    nameservers = [ "127.0.0.1" ];
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };
  };

  services.resolved.enable = false;
  systemd.network = {
    enable = true;
    networks."10-eth" = {
      matchConfig.Name = "end0";
      address = [ "192.168.1.3/24" ];
      networkConfig = {
        Gateway = "192.168.1.1";
        DNS = "127.0.0.1";
        DNSDefaultRoute = false;
      };
    };
  };

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINn2HFhSKi5iytR7UuY8H3I2vZ38I8VtmX7eY+kPmLRP"
    ];
    password = "";
  };
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "nixos" ];
      PermitRootLogin = "no";
    };
  };

  services.unbound = {
    enable = true;
    settings.server = {
      interface = [ "127.0.0.1" ];
      port = 5335;
      access-control = [ "127.0.0.1/32 allow" ];
      qname-minimisation = true;
      hide-identity = true;
      hide-version = true;
      harden-glue = true;
      harden-dnssec-stripped = true;
      root-hints = "${pkgs.dns-root-data}/root.hints";
      cache-max-ttl = 86400;
      cache-min-ttl = 300;
      use-caps-for-id = false;
      prefetch = true;
      prefetch-key = true;
      edns-buffer-size = 1232;
    };
    settings.forward-zone = [
      {
        name = ".";
        forward-tls-upstream = true;
        forward-addr = [
          "9.9.9.9@853#dns.quad9.net"
          "149.112.112.112@853#dns.quad9.net"
          "1.1.1.1@853#cloudflare-dns.com"
          "1.0.0.1@853#cloudflare-dns.com"
        ];
      }
    ];
  };

  # todo put my services in this bad boy
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    mutableSettings = true;
    host = "0.0.0.0";

    settings = {
      dns = {
        upstream_dns = [ "127.0.0.1:5335" ];
        bootstrap_dns = [
          "9.9.9.9"
          "149.112.112.112"
        ];
      };

      querylog = {
        file_enabled = false;
        interval = "24h";
        size_memory = 1000;
      };

      statistics.interval = "24h";

      filtering.protection_enabled = true;
      filtering.filtering_enabled = true;

      filters =
        map
          (url: {
            enabled = true;
            url = url;
          })
          [
            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt"
            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.txt"
          ];
    };
  };

  system.stateVersion = "26.05";
}
