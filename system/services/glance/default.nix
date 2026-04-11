{ ... }:
{
  # infra
  # clean https://github.com/glanceapp/community-widgets/blob/main/widgets/cloudflared-tunnels/README.md
  # https://github.com/glanceapp/community-widgets/blob/main/widgets/tailscale-devices/README.md
  # https://github.com/glanceapp/community-widgets/blob/main/widgets/netbird-devices/README.md
  # https://github.com/glanceapp/community-widgets/blob/main/widgets/forgejo-repos/README.md
  # https://github.com/glanceapp/community-widgets/blob/main/widgets/grafana/README.md
  # https://github.com/glanceapp/community-widgets/blob/main/widgets/github-actions-status/README.md
  # not adding but this looks clean as fuck https://github.com/glanceapp/community-widgets/blob/main/widgets/immich-styled/README.md
  # not adding but cool https://github.com/glanceapp/community-widgets/blob/main/widgets/minecraft-server/README.md

  # for user
  #https://github.com/glanceapp/community-widgets/blob/main/widgets/trending-github-repositories/README.md

  # https://github.com/glanceapp/community-widgets/blob/main/widgets/epic-free-widget/README.md
  # https://github.com/glanceapp/community-widgets/blob/main/widgets/steam-specials/README.md

  # also can set up authentication here instead
  # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#authentication

  # bill tin
  # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#dns-stats
  # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#server-stats
  # skycrab https://github.com/glanceapp/glance/blob/main/docs/configuration.md#twitch-channels

  #  time zone?
  #https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

  services.glance = {
    enable = true;
    settings = {
      server = {
        port = 8080;
        host = "0.0.0.0";
      };

      branding = {
        logo-text = "~";
        app-name = "Home";
        hide-footer = true;
      };

      theme = {
        background-color = "0 0 16";
        primary-color = "43 59 81";
        positive-color = "61 66 44";
        negative-color = "6 96 59";
        contrast-multiplier = 1.3;
        presets = {
          default-light = {
            light = true;
            background-color = "43 58 87";
            primary-color = "15 70 30";
            positive-color = "60 56 33";
            negative-color = "2 67 45";
            contrast-multiplier = 1.3;
            # text-saturation-multiplier = 0.9;
          };
        };
      };

      pages = [
        (import ./pages/home.nix)
        (import ./pages/news.nix)

        {
          name = "Dev";
          columns = [
            {
              size = "small";
              widgets = [
                # Search with dev bangs
                {
                  type = "search";
                  search-engine = "duckduckgo";
                  new-tab = true;
                  autofocus = true;
                  bangs = [
                    {
                      title = "GitHub";
                      shortcut = "!gh";
                      url = "https://github.com/search?q={QUERY}&type=repositories";
                    }
                    {
                      title = "Crates";
                      shortcut = "!cr";
                      url = "https://crates.io/search?q={QUERY}";
                    }
                    {
                      title = "NixOS Pkgs";
                      shortcut = "!nix";
                      url = "https://search.nixos.org/packages?query={QUERY}";
                    }
                    {
                      title = "NixOS Opts";
                      shortcut = "!nixo";
                      url = "https://search.nixos.org/options?query={QUERY}";
                    }
                    {
                      title = "Docs.rs";
                      shortcut = "!rs";
                      url = "https://docs.rs/{QUERY}";
                    }
                    {
                      title = "MDN";
                      shortcut = "!mdn";
                      url = "https://developer.mozilla.org/en-US/search?q={QUERY}";
                    }
                    {
                      title = "PyPI";
                      shortcut = "!py";
                      url = "https://pypi.org/search/?q={QUERY}";
                    }
                    {
                      title = "NPM";
                      shortcut = "!npm";
                      url = "https://www.npmjs.com/search?q={QUERY}";
                    }
                    {
                      title = "Man pages";
                      shortcut = "!man";
                      url = "https://man.archlinux.org/search?q={QUERY}";
                    }
                    {
                      title = "ArchWiki";
                      shortcut = "!aw";
                      url = "https://wiki.archlinux.org/index.php?search={QUERY}";
                    }
                    {
                      title = "NixWiki";
                      shortcut = "!nw";
                      url = "https://wiki.nixos.org/w/index.php?search={QUERY}";
                    }
                  ];
                }
                # Watched GitHub repos
                {
                  type = "repository";
                  title = "glance";
                  repository = "glanceapp/glance";
                  pull-requests-limit = 3;
                  issues-limit = 3;
                  commits-limit = 5;
                  # token = "TODO: set via env var GITHUB_TOKEN if rate limited";
                }
                {
                  type = "repository";
                  title = "nixpkgs";
                  repository = "NixOS/nixpkgs";
                  pull-requests-limit = 3;
                  issues-limit = 3;
                  commits-limit = 5;
                }
                # Dev blogs and newsletters
                {
                  type = "rss";
                  title = "Dev News";
                  style = "vertical-list";
                  limit = 15;
                  collapse-after = 6;
                  feeds = [
                    {
                      url = "https://this-week-in-rust.org/rss.xml";
                      title = "This Week in Rust";
                    }
                    {
                      url = "https://hnrss.org/best";
                      title = "HN Best";
                    }
                    {
                      url = "https://lobste.rs/rss";
                      title = "Lobsters";
                    }
                    {
                      url = "https://weekly.nixos.org/feeds/all.rss.xml";
                      title = "NixOS Weekly";
                    }
                    {
                      url = "https://thenewstack.io/feed/";
                      title = "The New Stack";
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                # Lobsters filtered to programming tags
                {
                  type = "lobsters";
                  title = "Lobsters: Programming";
                  limit = 20;
                  collapse-after = 8;
                  tags = [
                    "programming"
                    "plt"
                    "compilers"
                    "rust"
                    "linux"
                    "performance"
                  ];
                }
                # HN best sorted by engagement
                {
                  type = "hacker-news";
                  title = "HN Best";
                  limit = 20;
                  collapse-after = 8;
                  sort-by = "best";
                  extra-sort-by = "engagement";
                }
                # Security feeds
                {
                  type = "rss";
                  title = "Security";
                  style = "detailed-list";
                  limit = 15;
                  collapse-after = 5;
                  feeds = [
                    {
                      url = "https://feeds.feedburner.com/TheHackersNews";
                      title = "The Hacker News";
                    }
                    {
                      url = "https://www.bleepingcomputer.com/feed/";
                      title = "BleepingComputer";
                    }
                    {
                      url = "https://lobste.rs/t/security.rss";
                      title = "Lobsters Security";
                    }
                    {
                      url = "https://seclists.org/rss/fulldisclosure.rss";
                      title = "Full Disclosure";
                    }
                  ];
                }
              ];
            }
          ];
        }

        {
          name = "Start";
          width = "slim";
          hide-desktop-navigation = false;
          center-vertically = true;
          columns = [
            {
              size = "full";
              widgets = [
                # Service monitor — TODO: replace URLs with your actual services
                {
                  type = "monitor";
                  title = "Services";
                  cache = "1m";
                  sites = [
                    {
                      title = "Router";
                      url = "http://192.168.1.1";
                      icon = "mdi:router-network";
                    }
                    {
                      title = "Glance";
                      url = "http://localhost:8080";
                      icon = "sh:glance";
                    }
                    # Uncomment and edit as needed:
                    # { title = "Jellyfin";  url = "http://localhost:8096"; icon = "sh:jellyfin"; }
                    # { title = "Immich";    url = "http://localhost:2283"; icon = "sh:immich"; }
                    # { title = "Gitea";     url = "http://localhost:3000"; icon = "si:gitea"; }
                    # { title = "AdGuard";   url = "http://localhost:3000"; icon = "si:adguard"; }
                    # { title = "Vaultwarden"; url = "http://localhost:8880"; icon = "si:vaultwarden"; }
                    # { title = "qBittorrent"; url = "http://localhost:8080"; icon = "si:qbittorrent"; }
                  ];
                }
                {
                  type = "bookmarks";
                  groups = [
                    {
                      title = "Go to";
                      links = [
                        {
                          title = "GitHub";
                          url = "https://github.com";
                          icon = "si:github";
                        }
                        {
                          title = "YouTube";
                          url = "https://youtube.com";
                          icon = "si:youtube";
                        }
                        {
                          title = "HN";
                          url = "https://news.ycombinator.com";
                          icon = "si:ycombinator";
                        }
                        {
                          title = "Lobsters";
                          url = "https://lobste.rs";
                          icon = "mdi:lobster";
                        }
                        {
                          title = "NixOS Search";
                          url = "https://search.nixos.org";
                          icon = "si:nixos";
                        }
                        {
                          title = "MyNixOS";
                          url = "https://mynixos.com";
                          icon = "si:nixos";
                        }
                        {
                          title = "Sourcegraph";
                          url = "https://sourcegraph.com/search";
                          icon = "si:sourcegraph";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
