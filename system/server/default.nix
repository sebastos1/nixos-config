{ username, ... }:
{
  imports = [
    ./impermanence.nix
    ./backups.nix
    ./disko.nix
    ./dns
    ./vms.nix
  ];

  users.mutableUsers = false;
  users.users.${username} = {
    initialPassword = "init"; # change !
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINn2HFhSKi5iytR7UuY8H3I2vZ38I8VtmX7eY+kPmLRP"
    ];
  };

  networking.useNetworkd = true;
  systemd.network.enable = true;

  # stay alive
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore"; # closing lid doesn't put to sleep
    HandleSuspendKey = "ignore";
    HandleHibernateKey = "ignore";
  };
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  services.fail2ban.enable = true;
}
