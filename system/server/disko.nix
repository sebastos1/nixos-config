{ config, lib, ... }:
let
  cfg = config.server.disko;
  mountOptions = [
    "compress=zstd"
    "noatime"
  ];
in
{
  options.server.disko = {
    enable = lib.mkEnableOption "server disko";
    device = lib.mkOption {
      type = lib.types.str;
    };
    fsType = lib.mkOption {
      type = lib.types.str;
    };
    swapSize = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    persistenceDir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems."/var/log".neededForBoot = true;
    disko.devices.disk.main = {
      device = cfg.device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [
                "-L"
                "nixos"
                "-f"
              ];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  inherit mountOptions;
                };
                "/nix" = {
                  mountpoint = "/nix";
                  inherit mountOptions;
                };
                "/log" = {
                  mountpoint = "/var/log";
                  inherit mountOptions;
                };
              }
              // lib.optionalAttrs (cfg.persistenceDir != null) {
                ${cfg.persistenceDir} = {
                  mountpoint = cfg.persistenceDir;
                  inherit mountOptions;
                };
              };
            };
          };
        }
        // lib.optionalAttrs (cfg.swapSize != null) {
          swap = {
            size = cfg.swapSize;
            type = "8200";
            content.type = "swap";
          };
        };
      };
    };
  };
}
