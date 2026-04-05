# config
This language is unreadable

## profiles

| profile | description |
| - | - |
| desk | niri, apps, games |
| lap | niri, apps |
| server | zellij and server |

Use:
```sh
git clone https://github.com/sebastos1/nixos-config
cd nixos-config
nixos-rebuild switch --flake .#<profile>
```
There's also an alias `rebuild` that rebuilds the current profile.

# secrets
Agenix for keys, placed in `secrets/`.
```sh
agenix -e 
```
nails holy moly, noooo

todo
https://github.com/amaanq/nirinit
hardcoded wallpaper path yikes
tailscale
tie to vps
syncthing


# New machine
Build iso:
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

# root password doesn't matter anyway
sudo nixos-install --flake .#<host> --no-root-passwd
```

then reboot and the ip probably changed

If ever need to rebuild on the server, do:
```sh
sudo nixos-rebuild switch --flake github:sebastos1/nixos-config#<host>
```

Cloudflare tunnels, terranix:
Need:
- cf tunnel .json
- zone api key for opentofu to crank dns
```sh
nix run .#dns
```

Backups
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


VMs
Logs are forwarded so you can do
```sh
journalctl -m -u <servicename>
```
