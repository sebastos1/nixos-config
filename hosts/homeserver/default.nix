{
  mkImports,
  # inputs,
  config,
  mkVms,
  ...
}:
let
  imports = [
    /server.nix
  ];
in
{
  imports = [
    ./hardware.nix
    ./disk.nix
    ./impermanence.nix
    ./backups.nix

    (mkVms {
      subnetPrefix = "10.0.0";
      vms = [
        {
          name = "glance";
          services = [ ../../system/services/glance ];
        }
        {
          name = "forgejo";
          services = [ ../../system/services/forgejo.nix ];
          data = [
            {
              name = "forgejo-data";
              mountPoint = "/var/lib/forgejo";
            }
          ];
        }
        {
          name = "matrix";
          services = [ ../../system/services/matrix.nix ];
          data = [
            {
              name = "matrix-data";
              mountPoint = "/var/lib/continuwuity";
            }
          ];
        }
      ];
    })
  ]
  ++ mkImports ../../system imports;

  networking = {
    hostName = "Diorite";
    domain = "local";
    firewall.trustedInterfaces = [ "microvm" ];
    firewall.allowedTCPPorts = [
      22
      80
      443
      1234
      1235
    ];
  };

  systemd.network = {
    netdevs."10-microvm".netdevConfig = {
      Kind = "bridge";
      Name = "microvm";
    };
    networks = {
      "10-microvm" = {
        matchConfig.Name = "microvm";
        addresses = [ { Address = "10.0.0.1/24"; } ];
        networkConfig.ConfigureWithoutCarrier = true;
      };
      "11-microvm-tap" = {
        matchConfig.Name = "vm-*";
        networkConfig.Bridge = "microvm";
      };
    };
  };

  networking.nat = {
    enable = true;
    internalInterfaces = [ "microvm" ];
    externalInterface = "enp2s0";
    forwardPorts = [
      {
        destination = "10.0.0.2:8080";
        proto = "tcp";
        sourcePort = 1234;
      }
      {
        destination = "10.0.0.3:3000";
        proto = "tcp";
        sourcePort = 1235;
      }
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/microvms/matrix-vm/journal 0755 root root -"
    "L+ /var/log/journal/0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a - - - - /var/lib/microvms/matrix-vm/journal/0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a"
  ];

  age.secrets.cf-tunnel-json.file = ../../secrets/cf-tunnel-json.age;
  services.cloudflared = {
    enable = true;
    tunnels = {
      "3c4839a0-a5ff-4da1-8512-e00428fd24a5" = {
        credentialsFile = config.age.secrets.cf-tunnel-json.path;
        ingress = {
          "ssh.shlb.ng" = "ssh://localhost:22";
          # "sjallabong.com" = "http://localhost:3000";
          "pool.sjallabong.com" = "http://localhost:8080";
          "account.sjallabong.com" = "http://localhost:3001";

          "dash.shlb.ng" = "http://10.0.0.2:8080";
          "git.shlb.ng" = "http://10.0.0.3:3000";

          "matrix.sjallabong.com" = "http://10.0.0.4:6167";
          "sjallabong.com" = "http://10.0.0.4:8080";
        };
        default = "http_status:404";
      };
    };
  };

  system.stateVersion = "25.11";
}
