{
  pkgs,
  lib,
  ...
}:
let
  cinnyConfig = {
    allowCustomHomeservers = false;
    homeserverList = [ "sjallabong.com" ];
    defaultHomeserver = 0;
    hashRouter = {
      enabled = false;
      basename = "/";
    };
  };
in
{

  networking = {
    hostName = "matrix";
    useNetworkd = true;
    firewall.enable = false;
  };

  # users.users.root.password = "dontlook";
  # services.openssh = {
  #   enable = true;
  #   settings.PermitRootLogin = "yes";
  #   settings.PermitEmptyPasswords = "yes";
  # };

  systemd.network = {
    enable = true;
    networks."10-eth" = {
      matchConfig.Name = "e*";
      addresses = [ { Address = "10.0.0.4/24"; } ];
      routes = [ { Gateway = "10.0.0.1"; } ];
    };
  };

  systemd.services.matrix-continuwuity.serviceConfig.DynamicUser = lib.mkForce false;
  users.users.continuwuity = {
    isSystemUser = true;
    group = "continuwuity";
  };
  users.groups.continuwuity = { };

  microvm = {
    machineId = "0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a"; # todo gen
    hypervisor = "cloud-hypervisor";
    vcpu = 1;
    mem = 512;
    interfaces = [
      {
        type = "tap";
        id = "vm-matrix";
        mac = "02:00:00:00:00:03";
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
      {
        # ship the logs to host
        source = "/var/lib/microvms/matrix-vm/journal";
        mountPoint = "/var/log/journal";
        tag = "journal";
        proto = "virtiofs";
        socket = "journal.sock";
      }
    ];
    volumes = [
      {
        image = "matrix-data.img";
        mountPoint = "/var/lib/continuwuity";
        size = 2048;
      }
    ];
  };

  services.nginx = {
    enable = true;
    virtualHosts."sjallabong.com" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 8081;
        }
      ];
      root = pkgs.cinny;
      locations = {
        "/.well-known/matrix/" = {
          proxyPass = "http://127.0.0.1:6167";
        };
        "= /config.json".extraConfig = ''
          default_type application/json;
          return 200 '${lib.strings.toJSON cinnyConfig}';
        '';
      };
      extraConfig = ''
        rewrite ^/config.json$ /config.json break;
        rewrite ^/manifest.json$ /manifest.json break;
        rewrite ^/sw.js$ /sw.js break;
        rewrite ^/pdf.worker.min.js$ /pdf.worker.min.js break;
        rewrite ^/public/(.*)$ /public/$1 break;
        rewrite ^/assets/(.*)$ /assets/$1 break;
        rewrite ^(.+)$ /index.html break;
      '';
    };
  };

  # chills on 6167
  services.matrix-continuwuity = {
    enable = true;
    settings.global = {
      server_name = "sjallabong.com";
      address = [ "0.0.0.0" ];
      allow_registration = false;
      allow_encryption = true;
      allow_federation = true;
      trusted_servers = [ "matrix.org" ];
      new_user_displayname_suffix = "";
      well_known = {
        client = "https://matrix.sjallabong.com";
        server = "matrix.sjallabong.com:443";
      };
    };
  };

  system.stateVersion = "25.11";
}
