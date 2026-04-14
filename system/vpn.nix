{
  config,
  username,
  pkgs,
  ...
}:
{
  #todo put in better place
  users.users.${username}.packages = with pkgs; [
    curlie
    nmap
    doggo
    arp-scan
  ];

  networking.resolvconf.enable = false;
  services.resolved = {
    enable = true;
    settings.Resolve.DNSOverTLS = true;
  };

  services.mullvad-vpn.enable = true;
  systemd.services."mullvad-daemon".postStart =
    let
      mullvad = config.services.mullvad-vpn.package;
    in
    ''
      while ! ${mullvad}/bin/mullvad status >/dev/null; do sleep 1; done
      ${mullvad}/bin/mullvad auto-connect set on
      ${mullvad}/bin/mullvad lockdown-mode set on
      ${mullvad}/bin/mullvad tunnel set ipv6 on
      ${mullvad}/bin/mullvad lan set allow
      ${mullvad}/bin/mullvad dns set default --block-ads --block-trackers --block-malware
    '';
}
