{
  pkgs,
  lib,
  ...
}:
let
  cinnyConfig = {
    allowCustomHomeservers = false;
    homeserverList = [ "sjallabong.com" ];
    defaultHomeserver = 0;
    hashRouter = {
      enabled = false;
      basename = "/";
    };
  };
in
{
  services.nginx = {
    enable = true;
    virtualHosts."sjallabong.com" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8081;
        }
      ];
      root = pkgs.cinny;
      locations."= /config.json".extraConfig = ''
        default_type application/json;
        return 200 '${lib.strings.toJSON cinnyConfig}';
      '';
      extraConfig = ''
        rewrite ^/config.json$ /config.json break;
        rewrite ^/manifest.json$ /manifest.json break;
        rewrite ^/sw.js$ /sw.js break;
        rewrite ^/pdf.worker.min.js$ /pdf.worker.min.js break;
        rewrite ^/public/(.*)$ /public/$1 break;
        rewrite ^/assets/(.*)$ /assets/$1 break;
        rewrite ^(.+)$ /index.html break;
      '';
    };
  };

  # chills on 6167
  services.matrix-continuwuity = {
    enable = true;
    settings.global = {
      server_name = "sjallabong.com";
      allow_registration = false;
      allow_encryption = true;
      allow_federation = true;
      trusted_servers = [ "matrix.org" ];
      new_user_displayname_suffix = "";

      well_known = {
        client = "https://matrix.sjallabong.com";
        server = "matrix.sjallabong.com:443";
      };
    };
  };
}
