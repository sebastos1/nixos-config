{
  pkgs,
  lib,
  ...
}:
let
  domain = "sjallabong.com";
  matrix_domain = "matrix.sjallabong.com";
  cinnyConfig = {
    allowCustomHomeservers = false;
    homeserverList = [ domain ];
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
    virtualHosts.${domain} = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 8080;
        }
      ];
      root = pkgs.cinny;
      locations = {
        "/.well-known/matrix/" = {
          proxyPass = "http://127.0.0.1:6167";
        };
        "= /config.json".extraConfig = ''
          default_type application/json;
          return 200 '${lib.strings.toJSON cinnyConfig}';
        '';
        "/".extraConfig = ''
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
  };

  systemd.services.continuwuity.serviceConfig.DynamicUser = lib.mkForce false;
  users.users.continuwuity = {
    isSystemUser = true;
    group = "continuwuity";
  };
  users.groups.continuwuity = { };

  # chills on 6167
  services.matrix-continuwuity = {
    enable = true;
    settings.global = {
      server_name = domain;
      address = [ "0.0.0.0" ];
      allow_registration = false;
      allow_encryption = true;
      allow_federation = true;
      trusted_servers = [ "matrix.org" ];
      new_user_displayname_suffix = "";
      well_known = {
        client = "https://${matrix_domain}";
        server = "${matrix_domain}:443";
      };
    };
  };
}
