{
  ...
}:
{
  networking = {
    hostName = "matrix";
    useNetworkd = true;
    firewall.enable = false;
  };

  systemd.network = {
    enable = true;
    networks."10-eth" = {
      matchConfig.Name = "e*";
      addresses = [ { Address = "10.0.0.4/24"; } ];
      routes = [ { Gateway = "10.0.0.1"; } ];
    };
  };

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

  imports = [
    ../../system/services/matrix.nix
  ];

  system.stateVersion = "25.11";
}
