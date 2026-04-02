{
  terraform.required_providers.cloudflare = {
    source = "cloudflare/cloudflare";
    version = "~> 4";
  };

  resource.cloudflare_record =
    let
      zoneId = "71fc4efd9ff85d6e65f7bac4f1f8f91d";
      tunnelCname = "67f421c8-1836-4702-82c6-304741c443ac.cfargotunnel.com";
      mkTunnelRecord = name: {
        zone_id = zoneId;
        inherit name;
        content = tunnelCname;
        type = "CNAME";
        proxied = true;
      };
    in
    {
      sjallabong_root = mkTunnelRecord "@";
      sjallabong_matrix = mkTunnelRecord "matrix";
      sjallabong_pool = mkTunnelRecord "pool";
      sjallabong_account = mkTunnelRecord "account";
    };
}
