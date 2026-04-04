{
  nixpkgs,
  username,
  inputs,
  systemModules,
  sharedModules,
  ...
}:
let
  mkImports = base: paths: map (p: base + p) paths;

  mkSystem =
    name:
    nixpkgs.lib.nixosSystem {
      specialArgs = inputs // {
        inherit
          inputs
          username
          mkImports
          mkVms
          ;
      };
      modules = systemModules ++ [
        ./system
        ./hosts/${name}
        {
          home-manager = {
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            users.${username}.imports = [
              ./home
              ./hosts/${name}/home.nix
            ];
            extraSpecialArgs = inputs // {
              hostProfile = name;
              inherit username mkImports;
            };
            sharedModules = sharedModules;
          };
        }
      ];
    };

  mkSystems =
    names:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = mkSystem name;
      }) names
    );

  mkVm =
    {
      name,
      gateway,
      ip,
      mac,
      services ? [ ],
      data ? [ ],
      cid,
    }:
    {
      imports = services;
      networking = {
        hostName = name;
        useNetworkd = true;
        firewall.enable = false;
      };
      systemd.network = {
        enable = true;
        networks."10-eth" = {
          matchConfig.Name = "e*";
          addresses = [ { Address = "${ip}/24"; } ];
          routes = [ { Gateway = gateway; } ];
        };
      };
      microvm = {
        hypervisor = "cloud-hypervisor";
        machineId = builtins.hashString "md5" name;
        vcpu = 1;
        mem = 512;
        vsock.cid = cid;
        interfaces = [
          {
            type = "tap";
            id = "vm-${name}";
            mac = mac;
          }
        ];
        shares = [
          {
            proto = "virtiofs";
            tag = "ro-store";
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
          }
          {
            # ship the logs to host
            source = "/var/lib/microvms/${name}/journal";
            mountPoint = "/var/log/journal";
            tag = "journal";
            proto = "virtiofs";
            socket = "journal.sock";
          }
        ]
        # data volumes are mounted as virtiofs for btrfs
        ++ map (d: {
          proto = "virtiofs";
          tag = d.name;
          source = "/var/lib/microvms/${name}/${d.name}";
          mountPoint = d.mountPoint;
          socket = "${d.name}.sock";
        }) data;
      };
      system.stateVersion = "26.05";
    };

  mkVms =
    {
      subnetPrefix,
      vms,
    }:
    let
      gateway = "${subnetPrefix}.1";
      machineId = name: builtins.hashString "md5" name;
    in
    {
      microvm.vms = builtins.listToAttrs (
        nixpkgs.lib.imap0 (i: vm: {
          name = vm.name;
          value = {
            autostart = true;
            config.imports = [
              inputs.microvm.nixosModules.microvm
              (mkVm {
                inherit (vm) name;
                inherit gateway;
                ip = "${subnetPrefix}.${toString (i + 2)}";
                mac = "02:00:00:00:00:${nixpkgs.lib.fixedWidthString 2 "0" (toString (i + 1))}";
                services = vm.services or [ ];
                data = vm.data or [ ];
                cid = i + 3;
              })
            ];
          };
        }) vms
      );
      systemd.tmpfiles.rules = nixpkgs.lib.concatMap (
        vm:
        [
          "d /var/lib/microvms/${vm.name}/journal 0755 root root -"
          "L+ /var/log/journal/${machineId vm.name} - - - - /var/lib/microvms/${vm.name}/journal/${machineId vm.name}"
        ]
        ++ map (d: "q /var/lib/microvms/${vm.name}/${d.name} 0755 root root -") (vm.data or [ ])
      ) vms;
    };

in
{
  inherit mkSystems mkImports;
  inherit mkVms;
}
