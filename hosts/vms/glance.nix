{ ... }:
{
  networking = {
    hostName = "glance";
    useNetworkd = true;
    firewall.enable = false;
  };

  users.users.root.password = "dontlook";
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PermitEmptyPasswords = "yes";
  };

  systemd.network = {
    enable = true;
    networks."10-eth" = {
      matchConfig.Name = "e*";
      addresses = [ { Address = "10.0.0.2/24"; } ];
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
        id = "vm-glance";
        mac = "02:00:00:00:00:01";
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
  };

  services.glance = {
    enable = true;
    settings.server.port = 8080;
  };

  system.stateVersion = "25.11";
}
