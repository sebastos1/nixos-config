{ config, lib, ... }:
let
  cfg = config.server.impermanence;
in
{
  options.server.impermanence = {
    enable = lib.mkEnableOption "server impermanence";
    rootDir = lib.mkOption {
      type = lib.types.str;
      default = "/persist";
    };
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [ ];
    };
    files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.supportedFilesystems = [ "btrfs" ];
    programs.fuse.userAllowOther = true;
    boot.initrd.systemd = {
      enable = true;
      services.rollback = {
        description = "Rollback btrfs root subvolume";
        wantedBy = [ "initrd.target" ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir /btrfs_tmp
          mount -o subvol=/ /dev/disk/by-label/nixos /btrfs_tmp
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
      };
    };

    fileSystems.${cfg.rootDir}.neededForBoot = true;
    environment.persistence.${cfg.rootDir} = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
      ]
      ++ cfg.directories;
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ]
      ++ cfg.files;
    };
    age.identityPaths = [
      "${cfg.rootDir}/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
