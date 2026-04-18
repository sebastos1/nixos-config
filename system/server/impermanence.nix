{
  config,
  lib,
  pkgs,
  ...
}:
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
    boot.initrd.systemd.services.rollback = {
      description = "Rollback root subvolume";
      wantedBy = [ "initrd.target" ];
      after = [ "dev-disk-by\\x2dlabel-nixos.device" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "rollback" ''
          mkdir -p /mnt
          mount -t btrfs -o subvol=/ /dev/disk/by-label/nixos /mnt

          btrfs subvolume list -o /mnt/root | cut -f9 -d' ' | \
            while read subvolume; do
              btrfs subvolume delete "/mnt/$subvolume"
            done

          btrfs subvolume delete /mnt/root
          btrfs subvolume snapshot /mnt/root-blank /mnt/root

          umount /mnt
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
