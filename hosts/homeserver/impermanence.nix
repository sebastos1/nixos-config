{ lib, ... }:
{
  boot.initrd.supportedFilesystems = [ "btrfs" ];
  programs.fuse.userAllowOther = true;

  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-label/nixos /btrfs_tmp

    if [[ -e /btrfs_tmp/root ]]; then
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
      btrfs subvolume list -o "$i" | cut -f9 -d' ' |
        xargs -I{} btrfs subvolume delete "/btrfs_tmp/{}"
      btrfs subvolume delete "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  fileSystems."/persistent".neededForBoot = true;

  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/microvms"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}
