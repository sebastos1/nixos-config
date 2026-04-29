{ ... }:
{
  services.beszel = {
    hub = {
      enable = true;
      host = "0.0.0.0";
    };

    agent = {
      enable = true;
      environment = {
        LISTEN = "45876";
        TOKEN = "b846f769-f53b-4a8c-97c0-823fbf33bc24";
        KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRymEDCKye6Vacx1Cmiaf0nzrBwuNXlrhIhTEDWU9Ql";
        HUB_URL = "http://localhost:8090";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8090 ];
  # agent port (45876) doesn't need to be open since hub and agent are on the same machine
}
