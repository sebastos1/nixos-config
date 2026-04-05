{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.server.vms;
  machineId = name: builtins.hashString "md5" name;
in
{
  options.server.vms = {
    enable = lib.mkEnableOption "server microvms";
    gateway = lib.mkOption {
      type = lib.types.str;
      default = "10.0.0.1";
    };
    vms = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            ip = lib.mkOption { type = lib.types.str; };
            services = lib.mkOption {
              type = lib.types.listOf lib.types.anything;
              default = [ ];
            };
            data = lib.mkOption {
              type = lib.types.listOf (
                lib.types.submodule {
                  options = {
                    name = lib.mkOption { type = lib.types.str; };
                    mountPoint = lib.mkOption { type = lib.types.str; };
                  };
                }
              );
              default = [ ];
            };
          };
        }
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {

    # give vms a unique i for things that don't need to stay consistent
    microvm.vms = builtins.listToAttrs (
      lib.imap0 (
        i:
        { name, value }:
        let
          vm = value;
        in
        {
          # each vm
          inherit name;
          value = {
            autostart = true;
            config.imports = [
              inputs.microvm.nixosModules.microvm

              # vm
              {
                imports = vm.services;
                networking = {
                  hostName = name;
                  useNetworkd = true;
                  firewall.enable = false;
                };
                systemd.network = {
                  enable = true;
                  networks."10-eth" = {
                    matchConfig.Name = "e*";
                    addresses = [ { Address = "${vm.ip}/24"; } ];
                    routes = [ { Gateway = cfg.gateway; } ];
                  };
                };
                microvm = {
                  hypervisor = "cloud-hypervisor";
                  optimize.enable = true;
                  machineId = machineId name;
                  vcpu = 1;
                  mem = 512;
                  vsock.cid = i + 3;
                  interfaces = [
                    {
                      type = "tap";
                      id = "vm-${name}";
                      mac = "02:00:00:00:00:${lib.fixedWidthString 2 "0" (toString (i + 1))}";
                    }
                  ];
                  shares = [
                    {
                      # host store
                      proto = "virtiofs";
                      tag = "ro-store";
                      source = "/nix/store";
                      mountPoint = "/nix/.ro-store";
                    }
                    {
                      # send logs to host
                      proto = "virtiofs";
                      tag = "journal";
                      socket = "journal.sock";
                      source = "/var/lib/microvms/${name}/journal";
                      mountPoint = "/var/log/journal";
                    }
                  ]
                  ++ map (data: {
                    proto = "virtiofs";
                    tag = data.name;
                    socket = "${data.name}.sock";
                    source = "/var/lib/microvms/${name}/${data.name}";
                    mountPoint = data.mountPoint;
                  }) vm.data;
                };
                system.stateVersion = "26.05";
              }
            ];
          };
        }
      ) (lib.attrsToList cfg.vms)
    );

    systemd.tmpfiles.rules = lib.concatLists (
      lib.mapAttrsToList (name: vm: [
        # journal symlink
        "d /var/lib/microvms/${name}/journal 0755 root root -"
        "d /var/lib/microvms/${name}/journal/${machineId name} 0755 root root -"
        "L+ /var/log/journal/${machineId name} - - - - /var/lib/microvms/${name}/journal/${machineId name}"
      ]) cfg.vms
    );

    # tmpfiles can race, use activation script instaed
    system.activationScripts = lib.listToAttrs (
      lib.concatLists (
        lib.mapAttrsToList (
          name: vm:
          map (d: {
            name = "microvm-${name}-${d.name}";
            value.text = "mkdir -p /var/lib/microvms/${name}/${d.name}";
          }) vm.data
        ) cfg.vms
      )
    );
  };
}
