{ config, lib, ... }:
let
  cfg = config.server.disko;
  impermanenceCfg = config.server.impermanence;
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
    swapSize = lib.mkOption {
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
              type = "btrfs"; # -> subvolumes
              extraArgs = [
                # labels it nixos
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
              }
              // lib.optionalAttrs impermanenceCfg.enable {
                # keep logs on wipe
                "/log" = {
                  mountpoint = "/var/log";
                  inherit mountOptions;
                };
                "/root-blank" = { };
                ${impermanenceCfg.dir} = {
                  mountpoint = impermanenceCfg.dir;
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
