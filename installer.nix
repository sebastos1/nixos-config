{
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.sudo.wheelNeedsPassword = false;

  users.users.installer = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "install";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINn2HFhSKi5iytR7UuY8H3I2vZ38I8VtmX7eY+kPmLRP"
    ];
  };
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    disko
  ];

  console.keyMap = "no-latin1";
}
