# local tunnels + terranix standardizer so that i don't need to define them together and NEVER open the vile terranix file ever again
{ config, lib, ... }:
let
  cfg = config.server.dns;

  # flatten into { domain, id, subdomain, backend }
  allServices = builtins.concatLists (
    lib.mapAttrsToList (
      domain: zone:
      lib.mapAttrsToList (subdomain: backend: {
        inherit domain subdomain backend;
        zoneId = zone.id;
      }) zone.services
    ) cfg.zones
  );
in
{
  # cloudflared tunnel management
  options.server.dns = {
    enable = lib.mkEnableOption "goofy ahh cloudflared";
    tunnelId = lib.mkOption {
      type = lib.types.str;
    };
    secretsFile = lib.mkOption {
      type = lib.types.path;
    };
    zones = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            id = lib.mkOption {
              type = lib.types.str;
            };
            services = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              default = { };
            };
          };
        }
      );
      default = { };
    };
    # lets terra.nix get it
    allServices = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      readOnly = true;
      default = allServices;
    };
  };

  config = lib.mkIf cfg.enable {
    services.cloudflared = {
      enable = true;
      tunnels.${cfg.tunnelId} = {
        credentialsFile = cfg.secretsFile;
        ingress = builtins.listToAttrs (
          map (service: {
            name =
              if service.subdomain == "@" then service.domain else "${service.subdomain}.${service.domain}";
            value = service.backend;
          }) allServices
        );
        default = "http_status:404";
      };
    };
  };
}
