{ ... }:
{
  networking = {
    hostName = "forgejo";
    useNetworkd = true;
    firewall.enable = false;
  };

  systemd.network = {
    enable = true;
    networks."10-eth" = {
      matchConfig.Name = "e*";
      addresses = [ { Address = "10.0.0.3/24"; } ];
      routes = [ { Gateway = "10.0.0.1"; } ];
    };
  };

  microvm = {
    hypervisor = "cloud-hypervisor";
    vcpu = 1;
    mem = 512;
    interfaces = [
      {
        type = "tap";
        id = "vm-forgejo";
        mac = "02:00:00:00:00:02";
      }
    ];
    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ];
    volumes = [
      {
        image = "forgejo-data.img";
        mountPoint = "/var/lib/forgejo";
        size = 2048;
      }
    ];
  };

  services.forgejo = {
    enable = true;
    settings.server = {
      HTTP_ADDR = "0.0.0.0";
      HTTP_PORT = 3000;
    };
  };

  system.stateVersion = "25.11";
}
