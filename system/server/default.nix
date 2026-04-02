{ ... }:
{
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
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
}
