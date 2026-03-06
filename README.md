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
There's also an alias `rebuild` that rebuilds the current profile, but this assumes that the config is in `/etc/nixos`

## vpn

```sh
mullvad login
mullvad lockdown-mode set on
```

## Todo:
workspace renamer and workspace entry ordering (IMPORTANT)
https://github.com/swaywm/sway/wiki/Useful-add-ons-for-sway#workspaces
sov? alt+tabbing?
https://github.com/milgra/sov

ironbar?
