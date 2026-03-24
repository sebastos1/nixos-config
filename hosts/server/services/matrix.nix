{ config, pkgs, ... }:

{
  # chills on 6167
  services.matrix-continuwuity = {
    enable = true;
    settings = {
      global = {
        server_name = "sjallabong.com";
        allow_registration = false;
        allow_encryption = true;
        allow_federation = true;
        trusted_servers = [ "matrix.org" ];

        well_known = {
          client = "https://matrix.sjallabong.com";
          server = "matrix.sjallabong.com:443";
        };
      };
    };
  };
}
