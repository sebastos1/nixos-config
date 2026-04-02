{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      terranix.terranixConfigurations.dns = {
        terraformWrapper.package = pkgs.opentofu;
        modules = [
          (
            { lib, ... }:
            let
              tunnel = "29cf8536-1108-4b81-8cbb-ff6d84cdf120";
              target = "${tunnel}.cfargotunnel.com";
              zone = "71fc4efd9ff85d6e65f7bac4f1f8f91d";
              mkRecord = hostname: {
                zone_id = zone;
                name = hostname;
                content = target;
                type = "CNAME";
                proxied = true;
              };
            in
            {
              terraform.required_providers.cloudflare = {
                source = "cloudflare/cloudflare";
                version = "~> 5.0";
              };

              variable.cloudflare_api_token.sensitive = true;

              provider.cloudflare.api_token = "\${var.cloudflare_api_token}";

              resource.cloudflare_dns_record = {
                ssh_shlb_ng = mkRecord "ssh.shlb.ng";
                dash_shlb_ng = mkRecord "dash.shlb.ng";
                pool_sjallabong = mkRecord "pool.sjallabong.com";
                account_sjallabong = mkRecord "account.sjallabong.com";
                matrix_sjallabong = mkRecord "matrix.sjallabong.com";
                root_sjallabong = mkRecord "sjallabong.com";
              };
            }
          )
        ];
      };
    };
}
