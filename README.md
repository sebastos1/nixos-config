# config

## profiles

| profile | description |
| - | - |
| desk | sway, with apps and games (fat) |
| lap | sway, and dev things |
| server | zellij and whatever |

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
nails holy moly, noooo, 8 ball

todo
paralax scroller
remove window decoration bar
blur?
waybar workspaces
https://github.com/amaanq/nirinit
https://github.com/calico32/waybar-niri-windows
https://github.com/prankstr/vibepanel
