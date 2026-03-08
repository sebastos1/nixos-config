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
For new machines, to use secrets, use the host keys at `/etc/ssh/`

Adding key:
```sh
agenix -e 
```
