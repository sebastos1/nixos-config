{
  mkImports,
  config,
  username,
  ...
}:
let
  vms = {
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
    searxng = {
      ip = "10.0.0.5";
      services = [ ../../system/services/searxng.nix ];
    };
  };

  zones = {
    "shlb.ng" = {
      id = "e30b7a9147aac2d6283478a2c4d96919";
      services = {
        "ssh" = "ssh://localhost:22";
        "dash" = "http://localhost:8080";
        "git" = "http://${vms.forgejo.ip}:3000";
      };
    };
    "sjallabong.com" = {
      id = "71fc4efd9ff85d6e65f7bac4f1f8f91d";
      services = {
        "matrix" = "http://${vms.matrix.ip}:6167";
        "@" = "http://${vms.matrix.ip}:8080";
      };
    };
  };
in
{
  imports = mkImports ../../system [
    /server
    /services/glance
  ];

  home-manager.users.${username}.imports = mkImports ../../home [
    /cli
    /cli/headless.nix
    /editor/helix.nix
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
      addresses = true;
    };
  };

  server.impermanence = {
    enable = true;
    dir = "/persist";
    directories = [
      "/var/lib/microvms"
    ];
  };

  server.vms = {
    enable = true;
    inherit vms;
  };

  networking = {
    hostName = "Diorite";
    domain = "local";
    firewall.trustedInterfaces = [ "microvm" ];
    firewall.allowedTCPPorts = [
      22
      80
      443
      6767 # searxng
    ];

    nat = {
      enable = true;
      externalInterface = "en+"; # might be diff ?
      internalInterfaces = [ "vm-searxng" ]; # or your bridge, e.g. "br0"
      forwardPorts = [
        {
          sourcePort = 6767;
          destination = "10.0.0.5:6767";
          proto = "tcp";
        }
      ];
    };
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
    inherit zones;
  };

  server.backups = {
    enable = true;
    target = "/mnt/backups/diorite";
    subvolume = {
      "persist" = { };
    };
  };

  system.stateVersion = "25.11";
}
