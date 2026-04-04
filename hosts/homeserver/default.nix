{
  mkImports,
  config,
  ...
}:
let
  imports = [
    /server
  ];

  vms = {
    glance = {
      ip = "10.0.0.2";
      services = [ ../../system/services/glance ];
    };
    forgejo = {
      ip = "10.0.0.3";
      services = [ ../../system/services/forgejo.nix ];
      data = [
        {
          name = "forgejo-data";
          mountPoint = "/var/lib/forgejo";
        }
      ];
    };
    matrix = {
      ip = "10.0.0.4";
      services = [ ../../system/services/matrix.nix ];
      data = [
        {
          name = "matrix-data";
          mountPoint = "/var/lib/continuwuity";
        }
      ];
    };
  };

  zones = {
    "shlb.ng" = {
      id = "e30b7a9147aac2d6283478a2c4d96919";
      services = {
        "ssh" = "ssh://localhost:22";
        "dash" = "http://${vms.glance.ip}:8080";
        "git" = "http://${vms.forgejo.ip}:3000";
      };
    };
    "sjallabong.com" = {
      id = "71fc4efd9ff85d6e65f7bac4f1f8f91d";
      services = {
        # "pool" = "http://localhost:8080";
        # "account" = "http://localhost:3001";
        "matrix" = "http://${vms.matrix.ip}:6167";
        "@" = "http://${vms.matrix.ip}:8080";
      };
    };
  };
in
{
  imports = [
    ./hardware.nix
  ]
  ++ mkImports ../../system imports;

  server.backups = {
    enable = true;
    target = "/mnt/backups/diorite";
    subvolume = {
      "persist" = { };
    };
  };

  server.impermanence = {
    enable = true;
    rootDir = "/persist";
    directories = [ "/var/lib/microvms" ];
  };

  server.disko = {
    enable = true;
    device = "/dev/sda";
    fsType = "btrfs";
    swapSize = "8G";
    persistenceDir = "/persist";
  };

  server.vms = {
    enable = true;
    vms = vms;
  };

  networking = {
    hostName = "Diorite";
    domain = "local";
    firewall.trustedInterfaces = [ "microvm" ];
    firewall.allowedTCPPorts = [
      22
      80
      443
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

  age.secrets.cf-tunnel-json.file = ../../secrets/cf-tunnel-json.age;
  server.dns = {
    enable = true;
    tunnelId = "3c4839a0-a5ff-4da1-8512-e00428fd24a5";
    secretsFile = config.age.secrets.cf-tunnel-json.path;
    zones = zones;
  };

  system.stateVersion = "25.11";
}
