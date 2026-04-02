{
  mkImports,
  inputs,
  config,
  ...
}:
let
  imports = [
    /server
    /server/homepage.nix
  ];
in
{
  imports = [
    ./hardware.nix
  ]
  ++ mkImports ../../system imports;

  # 71fc4efd9ff85d6e65f7bac4f1f8f91d zoneid
  # age.secrets.cf-api-shlb = {
  #   file = ../../secrets/cf-api-shlb.age;
  #   owner = "seb";
  # };
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

  microvm.vms = {
    matrix-vm = {
      autostart = true;
      config = {
        imports = [
          inputs.microvm.nixosModules.microvm
          ../vms/matrix.nix
        ];
      };
    };

    forgejo-vm = {
      autostart = true;
      config = {
        imports = [
          inputs.microvm.nixosModules.microvm
          ../vms/forgejo.nix
        ];
      };
    };

    glance-vm = {
      autostart = true;
      config = {
        imports = [
          inputs.microvm.nixosModules.microvm
          ../vms/glance.nix
        ];
      };
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

  age.secrets.cf-tunnel-json.file = ../../secrets/cf-tunnel-json.age;
  services.cloudflared = {
    enable = true;
    tunnels = {
      "29cf8536-1108-4b81-8cbb-ff6d84cdf120" = {
        credentialsFile = config.age.secrets.cf-tunnel-json.path;
        ingress = {
          "ssh.shlb.ng" = "ssh://localhost:22";
          # "sjallabong.com" = "http://localhost:3000";
          "pool.sjallabong.com" = "http://localhost:8080";
          "account.sjallabong.com" = "http://localhost:3001";

          "dash.shlb.ng" = "http://10.0.0.2:8080";
          "git.shlb.ng" = "http://10.0.0.3:3000";

          "matrix.sjallabong.com" = "http://10.0.0.4:6167";
          # "sjallabong.com" = {
          #   service = "http://10.0.0.4:6167"; # /.well-known
          #   path = "/.well-known/matrix/.*";
          # };
          "sjallabong.com" = "http://10.0.0.4:8081";
        };
        default = "http_status:404";
      };
    };
  };

  system.stateVersion = "25.11";
}
