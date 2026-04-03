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
sudo disko --mode destroy,format,mount hosts/<host>/disk.nix 

# root password doesn't matter anyway
sudo nixos-install --flake .#<host> --no-root-passwd
```

then reboot and the ip probably changed

TODO cloudflare bullshit >:c, terranix
