{
  # physical btrfs partition root
  fileSystems."/mnt/btrfs-root" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [
      "subvolid=5"
      "noatime"
    ];
  };

  # ssd must have label "backups"
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

  # btrfs really doesnt want to make folders
  systemd.tmpfiles.rules = [
    "d /mnt/btrfs-root/snapshots 0755 root root -"
    "d /mnt/backups/diorite 0755 root root -"
  ];

  services.btrbk.instances."ssd-backup" = {
    onCalendar = "daily";
    settings = {
      snapshot_preserve_min = "2d";
      snapshot_preserve = "7d";

      target_preserve_min = "7d";
      target_preserve = "30d 10w";

      volume."/mnt/btrfs-root" = {
        subvolume = "persistent";
        snapshot_dir = "snapshots";
        target = "/mnt/backups/diorite";
      };
    };
  };
}
