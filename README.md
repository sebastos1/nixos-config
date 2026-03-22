# config

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
paralax scroller
blur?
https://github.com/amaanq/nirinit
