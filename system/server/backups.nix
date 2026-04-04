{ config, lib, ... }:
let
  cfg = config.server.backups;
in
{
  options.server.backups = {
    enable = lib.mkEnableOption "server backups";
    target = lib.mkOption {
      type = lib.types.str;
    };
    subVolume = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };
    btrfsRoot = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/btrfs-root";
    };
  };

  config = lib.mkIf cfg.enable {
    # physical btrfs partition root
    fileSystems.${cfg.btrfsRoot} = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvolid=5"
        "noatime"
      ];
    };

    # assuming backups are labeled "backups"
    fileSystems."/mnt/backups" = {
      device = "/dev/disk/by-label/backups";
      fsType = "btrfs";
      options = [
        "noauto"
        "nofail"
        "compress=zstd"
        "x-systemd.automount"
      ];
    };

    # backup service
    services.btrbk.instances."backup" = {
      onCalendar = "daily";
      settings = {
        snapshot_preserve_min = "2d";
        snapshot_preserve = "7d";
        target_preserve_min = "7d";
        target_preserve = "30d 10w";
        volume.${cfg.btrfsRoot} = {
          snapshot_dir = "snapshots";
          inherit (cfg) target subVolume;
        };
      };
    };

    # btrfs really doesnt want to make folders
    systemd.tmpfiles.rules = [
      "d ${cfg.btrfsRoot}/snapshots 0755 root root -"
      "d ${cfg.target} 0755 root root -"
    ];
  };
}
