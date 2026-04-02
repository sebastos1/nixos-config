{ lib, ... }:
let
  tunnel = "29cf8536-1108-4b81-8cbb-ff6d84cdf120";
  target = "${tunnel}.cfargotunnel.com";
  zone = "71fc4efd9ff85d6e65f7bac4f1f8f91d";

  mkRecord = zone: hostname: {
    "${hostname}" = {
      zone_id = zone;
      name = hostname;
      content = target;
      type = "CNAME";
      proxied = true;
    };
  };
in
{
  terraform.required_providers.cloudflare = {
    source = "cloudflare/cloudflare";
    version = "~> 5";
  };

  provider.cloudflare = {
    api_token = "\${var.cloudflare_api_token}";
  };

  resource.cloudflare_dns_record =
    (mkRecord zone "ssh.shlb.ng")
    // (mkRecord zone "dash.shlb.ng")
    // (mkRecord zone "pool.sjallabong.com")
    // (mkRecord zone "account.sjallabong.com")
    // (mkRecord zone "matrix.sjallabong.com")
    // (mkRecord zone "sjallabong.com");
}
