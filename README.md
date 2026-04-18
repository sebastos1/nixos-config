# config
This language is unreadable. also ijkl

todo
https://github.com/amaanq/nirinit
hardcoded wallpaper path yikes
netbird
tie to vps
syncthing

## use
Use:
```sh
git clone https://github.com/sebastos1/nixos-config
cd nixos-config
sudo nixos-rebuild switch --flake .#<profile>
```
There's also a `rebuild` alias that rebuilds the current profile.

## hosts
| host | description |
| - | - |
| desk | niri, apps, games |
| lap | niri, apps |
| homeserver | server things todo |

### new host
```sh
 hosts
├──  desk
│   ├──  default.nix
│   └──  hardware.nix
├──  lap
│   ├──  default.nix
│   └──  hardware.nix
└──  new_host
    ├──  default.nix
    │   ├── imports = mkImports ../../system [ ];
    │   └── home-manager.users.${username}.imports = mkImports ../../home [ ];
    └──  hardware.nix
```

And register the host in the flake:
```nix
{
  outputs = { nixpkgs, flake-parts, ... }@inputs:
    let
      username = "seb";
      hosts = [
        "homeserver"
        "desk"
        "lap"
      ];
      configPath = "/etc/nixos"; # or github:sebastos1/nixos-config
    in
```

## structure
```sh
├──  system
│   ├──  default.nix # common options
│   ├──  client # workstations, laptops, physical machines
│   ├──  server # server machine options
│   ├──  services # things mostly on servers, but not related to server config itself
│   └──  other.nix # other common options go in here for now
│
├── 󱂵 home
│   ├──  default.nix # common
│   ├──  cli # used for servers too
│   ├──  desktop # wm, compositor, bars, anything desktop
│   ├──  editors # necessity
│   ├──  browser # necessity #2
│   └──  apps # less important, anything else really
│       ├──  default.nix
│       ├──  minecraft
│       └──  music.nix
│
└──  hosts 
    ├──  desk
    │   ├──  default.nix
    │   └──  hardware.nix # hardware-configuration.nix, modified usually
    ├──  homeserver
    └──  lap
```

## secrets
Agenix for keys, placed in `secrets/`.
```sh
agenix -e 
```

## installer
Set SSH key of machine accessing in the `installer.nix` (`openssh.authorizedKeys.keys`), then build iso:
```sh
nix build .#nixosConfigurations.installer.config.system.build.isoImage
sudo dd status=progress bs=4M if=result/iso/<ermm> of=/dev/<sdX>
```

Boot into this iso and just get ip (`ip a`), then on main machine:
```sh
ssh seb@<ip>
git clone https://github.com/sebastos1/nixos-config /tmp/config
cd /tmp/config

# NEVER do manual disk setup again! define disk setup somewhere (todo, my fault g)
sudo disko --mode destroy,format,mount --flake .#<host> # --yes-wipe-all-disks
# sudo disko --mode destroy,format,mount --flake .#homeserver --yes-wipe-all-disks

# root password doesn't matter anyway
sudo nixos-install --flake .#<host> --no-root-passwd
```

then reboot and the ip probably changed

can rebuild with this. alias ? todo
```sh
sudo nixos-rebuild switch --flake github:sebastos1/nixos-config#<host>
```

### dns
Cloudflare tunnels, terranix:
Need:
- cf tunnel .json
- zone api key for opentofu to crank dns
```sh
nix run .#dns
```

### backups
```sh 
sudo parted /dev/<erm> -- mkpart primary btrfs 0% 100%
sudo mkfs.btrfs -L backups /dev/<erm>1 -f # important label
```
Then:
```sh
# perform a manual backup (runs at 00:00 currently)
sudo systemctl start btrbk-backup.service
ls /mnt/backups/diorite/
# should show a new persistent.<timestamp> entry
```
todo luks

### vms
VMs
Logs are forwarded so you can do
```sh
journalctl -m -u <servicename>
```


### rpi
https://frederikstroem.com/journal/bootstrapping-nixos-on-a-headless-raspberry-pi-4
```
sudo mkdir -p home/nixos/.ssh
echo "ssgh skdjfsdjkhfsdjkhfks" | sudo tee home/nixos/.ssh/authorized_keys
sudo chown -R 1000:100 home/nixos/.ssh
sudo chmod 700 home/nixos/.ssh
sudo chmod 600 home/nixos/.ssh/authorized_keys
```

THen:
```
sudo arp-scan --localnet
ssh nixos@<ip>
```
