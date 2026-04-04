{ dns, lib, ... }:
{
  terraform.required_providers.cloudflare = {
    source = "cloudflare/cloudflare";
    version = "~> 5.0";
  };
  variable.cloudflare_api_token.sensitive = true;
  provider.cloudflare.api_token = "\${var.cloudflare_api_token}";
  resource.cloudflare_dns_record = builtins.listToAttrs (
    builtins.concatLists (
      lib.mapAttrsToList (
        hostname: hostDns:
        map (service: {
          name =
            builtins.replaceStrings [ "@" "." "-" ] [ "at" "_" "_" ]
              "${service.subdomain}_${service.domain}_${hostname}";
          value = {
            zone_id = service.zoneId;
            name = service.subdomain;
            content = "${hostDns.tunnelId}.cfargotunnel.com";
            type = "CNAME";
            proxied = true;
            ttl = 1;
          };
        }) hostDns.allServices
      ) dns
    )
  );
}

# { self, lib, ... }:
# {
#   perSystem =
#     { pkgs, ... }:
#     {
#       terranix.terranixConfigurations.dns = {
#         terraformWrapper.package = pkgs.opentofu;
#         modules = [
#           (
#             let
#               tunnel = "3c4839a0-a5ff-4da1-8512-e00428fd24a5";
#               shlb = "e30b7a9147aac2d6283478a2c4d96919";
#               sjallabong = "71fc4efd9ff85d6e65f7bac4f1f8f91d";
#               mkRecord = zone: name: {
#                 zone_id = zone;
#                 name = name;
#                 content = "${tunnel}.cfargotunnel.com";
#                 type = "CNAME";
#                 proxied = true;
#                 ttl = 1;
#               };
#             in
#             {
#               terraform.required_providers.cloudflare = {
#                 source = "cloudflare/cloudflare";
#                 version = "~> 5.0";
#               };

#               variable.cloudflare_api_token.sensitive = true;

#               provider.cloudflare.api_token = "\${var.cloudflare_api_token}";

#               resource.cloudflare_dns_record = {
#                 ssh_shlb = mkRecord shlb "ssh";
#                 git_shlb = mkRecord shlb "git";
#                 dash_shlb = mkRecord shlb "dash";
#                 pool_sjallabong = mkRecord sjallabong "pool";
#                 account_sjallabong = mkRecord sjallabong "account";
#                 matrix_sjallabong = mkRecord sjallabong "matrix";
#                 root_sjallabong = mkRecord sjallabong "@";
#               };
#             }
#           )
#         ];
#       };
#     };
# }
