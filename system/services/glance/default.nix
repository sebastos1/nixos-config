{ ... }:
{
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

      pages = [
        {
          name = "Home";
          width = "slim";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "clock";
                  hour-format = "24h";
                  timezones = [
                    {
                      timezone = "Europe/Oslo";
                      label = "Oslo";
                    }
                  ];
                }
                {
                  type = "calendar";
                  first-day-of-week = "monday";
                }
                {
                  type = "weather";
                  location = "Oslo, Norway";
                  units = "metric";
                  hour-format = "24h";
                  show-area-name = false;
                }
                {
                  type = "to-do";
                  id = "main";
                  title = "Today";
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "rss";
                  title = "News";
                  style = "detailed-list";
                  limit = 12;
                  collapse-after = -1;
                  feeds = [
                    {
                      url = "https://feeds.bbci.co.uk/news/rss.xml";
                      title = "BBC";
                    }
                    {
                      url = "https://rss.reuters.com/reuters/topNews";
                      title = "Reuters";
                    }
                    {
                      url = "https://feeds.skynews.com/feeds/rss/home.xml";
                      title = "Sky News";
                    }
                    {
                      url = "https://www.nrk.no/toppsaker.rss";
                      title = "NRK";
                    }
                  ];
                }
              ];
            }
          ];
        }

        # ============================================================
        # PAGE 2: FEED — deep reading, news and blogs
        # full | small layout
        # ============================================================
        {
          name = "Feed";
          width = "wide";
          columns = [
            {
              size = "full";
              widgets = [
                # Wide horizontal card strip at the top — visual headlines
                {
                  type = "rss";
                  title = "World News";
                  style = "horizontal-cards-2";
                  card-height = 20;
                  limit = 8;
                  feeds = [
                    {
                      url = "https://feeds.bbci.co.uk/news/world/rss.xml";
                      title = "BBC World";
                    }
                    {
                      url = "https://feeds.bbci.co.uk/news/technology/rss.xml";
                      title = "BBC Tech";
                    }
                    {
                      url = "https://rss.nytimes.com/services/xml/rss/nyt/World.xml";
                      title = "NYT";
                    }
                    {
                      url = "https://feeds.skynews.com/feeds/rss/world.xml";
                      title = "Sky News";
                    }
                    {
                      url = "https://www.aljazeera.com/xml/rss/all.xml";
                      title = "Al Jazeera";
                    }
                  ];
                }
                # Science & research
                {
                  type = "rss";
                  title = "Science";
                  style = "vertical-list";
                  limit = 15;
                  collapse-after = 6;
                  feeds = [
                    {
                      url = "https://www.science.org/rss/news_current.xml";
                      title = "Science";
                    }
                    {
                      url = "https://feeds.nature.com/nature/rss/current";
                      title = "Nature";
                    }
                    {
                      url = "https://www.newscientist.com/feed/home";
                      title = "New Scientist";
                    }
                    {
                      url = "https://www.quantamagazine.org/feed/";
                      title = "Quanta";
                    }
                    {
                      url = "https://phys.org/rss-feed/";
                      title = "Phys.org";
                    }
                  ];
                }
                # Long reads and essays
                {
                  type = "rss";
                  title = "Long Reads";
                  style = "detailed-list";
                  limit = 12;
                  collapse-after = 5;
                  feeds = [
                    {
                      url = "https://www.theguardian.com/news/rss";
                      title = "Guardian";
                    }
                    {
                      url = "https://www.theatlantic.com/feed/all/";
                      title = "The Atlantic";
                    }
                    {
                      url = "https://www.newyorker.com/feed/everything";
                      title = "New Yorker";
                    }
                    {
                      url = "https://aeon.co/feed.rss";
                      title = "Aeon";
                    }
                    {
                      url = "https://psyche.co/feed";
                      title = "Psyche";
                    }
                    {
                      url = "https://nautil.us/feed";
                      title = "Nautilus";
                    }
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                # Hacker News new (different from top on home page)
                {
                  type = "hacker-news";
                  title = "HN: New";
                  limit = 20;
                  collapse-after = 8;
                  sort-by = "new";
                }
                # Indie/personal blogs
                {
                  type = "rss";
                  title = "Blogs";
                  style = "vertical-list";
                  limit = 20;
                  collapse-after = 8;
                  feeds = [
                    {
                      url = "https://jvns.ca/atom.xml";
                      title = "Julia Evans";
                    }
                    {
                      url = "https://rachelbythebay.com/w/atom.txt";
                      title = "rachelbythebay";
                    }
                    {
                      url = "https://tonsky.me/atom.xml";
                      title = "Nikita Prokopov";
                    }
                    {
                      url = "https://macwright.com/atom.xml";
                      title = "Tom MacWright";
                    }
                    {
                      url = "https://danluu.com/atom.xml";
                      title = "Dan Luu";
                    }
                    {
                      url = "https://without.boats/blog/index.xml";
                      title = "without.boats";
                    }
                    {
                      url = "https://matklad.github.io/feed.xml";
                      title = "matklad";
                    }
                    {
                      url = "https://www.scattered-thoughts.net/atom.xml";
                      title = "scattered-thoughts";
                    }
                    {
                      url = "https://ntietz.com/atom.xml";
                      title = "Nicole Tietz";
                    }
                  ];
                }
              ];
            }
          ];
        }

        # ============================================================
        # PAGE 3: VIDEOS — YouTube and Twitch
        # full layout, head widget for search
        # ============================================================
        {
          name = "Videos";
          columns = [
            {
              size = "full";
              widgets = [
                # Tech channels — grid cards
                {
                  type = "videos";
                  title = "Tech";
                  style = "grid-cards";
                  collapse-after-rows = 2;
                  include-shorts = false;
                  channels = [
                    "UCXuqSBlHAE6Xw-yeJA0Tunw" # Linus Tech Tips
                    "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                    "UCsBjURrPoezykLs9EqgamOA" # Fireship
                    "UCBJycsmduvYEL83R_U4JriQ" # MKBHD
                    "UCHnyfMqiRRG1u-2MsSQLbXA" # Veritasium
                    "UCV0qA-eDDICsRR9rPcnG7tw" # Low Level Learning
                    "UCVls1GmFKf6WlTraIb_IaJg" # DistroTube
                    "UC7YOGHUfC1Tb2alpyB7BWkA" # ThePrimeagen (vods)
                    "UCWX3ygvOAUOFKsXVlGiONFg" # Chris Titus Tech
                    "UCGbg3DjQdcqWwqOLHpYHXIg" # Wolfgang's Channel
                  ];
                }
                # Dev & programming — vertical list
                {
                  type = "videos";
                  title = "Programming";
                  style = "vertical-list";
                  collapse-after = 8;
                  include-shorts = false;
                  channels = [
                    "UCwRXb5dUK4cvsHbx-rGzSgw" # Code Bullet
                    "UC4SVo0Ue36XCfOyb5Lh1viQ" # b001
                    "UC3s0BtrBJpwNDaflRSoiieQ" # Theo - t3.gg
                    "UC2eYFnH61tmytImy1mTYvhA" # Luke Smith
                    "UCkYqhFNmhCzkefHsHS652hw" # GopherCon
                  ];
                }
                # Science / educational
                {
                  type = "videos";
                  title = "Science & Learning";
                  style = "grid-cards";
                  collapse-after-rows = 1;
                  include-shorts = false;
                  channels = [
                    "UCsXVk37bltHxD1rDPwtNM8Q" # Kurzgesagt
                    "UCHnyfMqiRRG1u-2MsSQLbXA" # Veritasium
                    "UC6nSFpj9HTCZ5t-N3Rm3-HA" # Vsauce
                    "UCbmNph6atAoGfqLoCL_duAg" # Tibees
                    "UCoxcjq-8xIDTYp3uz647V5A" # Numberphile
                  ];
                }
              ];
            }
          ];
        }

        # ============================================================
        # PAGE 4: DEV — development focused
        # small | full layout
        # ============================================================
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

        # ============================================================
        # PAGE 5: LINUX — open source and Linux world
        # full | small layout
        # ============================================================
        {
          name = "Linux";
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "rss";
                  title = "Linux & FOSS";
                  style = "horizontal-cards";
                  thumbnail-height = 10;
                  limit = 10;
                  feeds = [
                    {
                      url = "https://www.phoronix.com/rss.php";
                      title = "Phoronix";
                    }
                    {
                      url = "https://itsfoss.com/feed/";
                      title = "It's FOSS";
                    }
                    {
                      url = "https://www.omgubuntu.co.uk/feed";
                      title = "OMG Ubuntu";
                    }
                    {
                      url = "https://lwn.net/headlines/rss";
                      title = "LWN.net";
                    }
                    {
                      url = "https://9to5linux.com/feed/atom";
                      title = "9to5Linux";
                    }
                  ];
                }
                {
                  type = "rss";
                  title = "Kernel & Systems";
                  style = "detailed-list";
                  limit = 15;
                  collapse-after = 6;
                  feeds = [
                    {
                      url = "https://lwn.net/headlines/rss";
                      title = "LWN";
                    }
                    {
                      url = "https://lore.kernel.org/lkml/?q=&x=A&o=0&e=100";
                      title = "LKML";
                    }
                    {
                      url = "https://feeds.feedburner.com/linuxsecurity-com/YbpT";
                      title = "Linux Security";
                    }
                  ];
                }
                {
                  type = "rss";
                  title = "Self-Hosting & Homelab";
                  style = "vertical-list";
                  limit = 15;
                  collapse-after = 6;
                  feeds = [
                    {
                      url = "https://selfh.st/rss/";
                      title = "selfh.st";
                    }
                    {
                      url = "https://noted.lol/rss/";
                      title = "noted.lol";
                    }
                    {
                      url = "https://www.linuxserver.io/blog/feed.xml";
                      title = "LinuxServer.io";
                    }
                    {
                      url = "https://blog.ktz.me/rss/";
                      title = "Alex Kretzschmar";
                    }
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "releases";
                  title = "Linux Releases";
                  show-source-icon = true;
                  collapse-after = 8;
                  repositories = [
                    "NixOS/nixpkgs"
                    "NixOS/nix"
                    "nix-community/home-manager"
                    "torvalds/linux"
                    "systemd/systemd"
                    "containers/podman"
                    "containers/buildah"
                    "opencontainers/runc"
                    "moby/moby"
                    "lima-vm/lima"
                  ];
                }
                {
                  type = "rss";
                  title = "NixOS";
                  style = "vertical-list";
                  limit = 15;
                  collapse-after = 7;
                  feeds = [
                    {
                      url = "https://weekly.nixos.org/feeds/all.rss.xml";
                      title = "NixOS Weekly";
                    }
                    {
                      url = "https://nixos.org/blog/announcements-rss.xml";
                      title = "NixOS Announcements";
                    }
                    {
                      url = "https://discourse.nixos.org/c/links.rss";
                      title = "NixOS Discourse Links";
                    }
                  ];
                }
              ];
            }
          ];
        }

        # ============================================================
        # PAGE 6: FINANCE — markets and money
        # small | full | small layout
        # ============================================================
        {
          name = "Finance";
          head-widgets = [
            {
              type = "markets";
              hide-header = true;
              markets = [
                {
                  symbol = "SPY";
                  name = "S&P 500";
                }
                {
                  symbol = "QQQ";
                  name = "NASDAQ 100";
                }
                {
                  symbol = "DIA";
                  name = "Dow Jones";
                }
                {
                  symbol = "VTI";
                  name = "Total Market";
                }
                {
                  symbol = "BTC-USD";
                  name = "Bitcoin";
                }
                {
                  symbol = "ETH-USD";
                  name = "Ethereum";
                }
                {
                  symbol = "SOL-USD";
                  name = "Solana";
                }
                {
                  symbol = "GLD";
                  name = "Gold";
                }
                {
                  symbol = "TLT";
                  name = "20Y Treasury";
                }
                {
                  symbol = "DXY";
                  name = "Dollar Index";
                }
              ];
            }
          ];
          columns = [
            {
              size = "small";
              widgets = [
                # Individual stocks watchlist
                {
                  type = "markets";
                  title = "Tech Stocks";
                  markets = [
                    {
                      symbol = "NVDA";
                      name = "NVIDIA";
                    }
                    {
                      symbol = "AMD";
                      name = "AMD";
                    }
                    {
                      symbol = "INTC";
                      name = "Intel";
                    }
                    {
                      symbol = "AAPL";
                      name = "Apple";
                    }
                    {
                      symbol = "MSFT";
                      name = "Microsoft";
                    }
                    {
                      symbol = "GOOG";
                      name = "Alphabet";
                    }
                    {
                      symbol = "META";
                      name = "Meta";
                    }
                    {
                      symbol = "AMZN";
                      name = "Amazon";
                    }
                    {
                      symbol = "TSLA";
                      name = "Tesla";
                    }
                    {
                      symbol = "NET";
                      name = "Cloudflare";
                    }
                    {
                      symbol = "PLTR";
                      name = "Palantir";
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                # Finance news feeds
                {
                  type = "rss";
                  title = "Markets News";
                  style = "horizontal-cards";
                  thumbnail-height = 10;
                  limit = 10;
                  feeds = [
                    {
                      url = "https://feeds.bloomberg.com/markets/news.rss";
                      title = "Bloomberg Markets";
                    }
                    {
                      url = "https://feeds.reuters.com/reuters/businessNews";
                      title = "Reuters Business";
                    }
                    {
                      url = "https://feeds.feedburner.com/wsj/xml/rss/3_7085.xml";
                      title = "WSJ Markets";
                    }
                  ];
                }
                {
                  type = "rss";
                  title = "Finance Deep Reads";
                  style = "detailed-list";
                  limit = 15;
                  collapse-after = 6;
                  feeds = [
                    {
                      url = "https://www.ft.com/rss/home/uk";
                      title = "Financial Times";
                    }
                    {
                      url = "https://feeds.a.dj.com/rss/RSSWSJD.xml";
                      title = "WSJ";
                    }
                    {
                      url = "https://seekingalpha.com/feed.xml";
                      title = "Seeking Alpha";
                    }
                    {
                      url = "https://feeds.feedburner.com/marginalrevolution/feed";
                      title = "Marginal Revolution";
                    }
                    {
                      url = "https://www.economist.com/finance-and-economics/rss.xml";
                      title = "The Economist";
                    }
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                # Crypto
                {
                  type = "markets";
                  title = "Crypto";
                  markets = [
                    {
                      symbol = "BTC-USD";
                      name = "Bitcoin";
                    }
                    {
                      symbol = "ETH-USD";
                      name = "Ethereum";
                    }
                    {
                      symbol = "SOL-USD";
                      name = "Solana";
                    }
                    {
                      symbol = "LINK-USD";
                      name = "Chainlink";
                    }
                    {
                      symbol = "DOT-USD";
                      name = "Polkadot";
                    }
                    {
                      symbol = "ADA-USD";
                      name = "Cardano";
                    }
                    {
                      symbol = "DOGE-USD";
                      name = "Dogecoin";
                    }
                  ];
                }
                {
                  type = "rss";
                  title = "Crypto News";
                  style = "vertical-list";
                  limit = 15;
                  collapse-after = 6;
                  feeds = [
                    {
                      url = "https://cointelegraph.com/rss";
                      title = "CoinTelegraph";
                    }
                    {
                      url = "https://www.coindesk.com/arc/outboundfeeds/rss/";
                      title = "CoinDesk";
                    }
                    {
                      url = "https://decrypt.co/feed";
                      title = "Decrypt";
                    }
                  ];
                }
              ];
            }
          ];
        }

        # ============================================================
        # PAGE 7: STARTPAGE — minimal browser homepage
        # slim, centered, search + monitor + bookmarks
        # ============================================================
        {
          name = "Start";
          width = "slim";
          hide-desktop-navigation = false;
          center-vertically = true;
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  autofocus = true;
                  new-tab = true;
                  search-engine = "duckduckgo";
                  placeholder = "Search or !bang";
                  bangs = [
                    {
                      title = "YouTube";
                      shortcut = "!yt";
                      url = "https://www.youtube.com/results?search_query={QUERY}";
                    }
                    {
                      title = "GitHub";
                      shortcut = "!gh";
                      url = "https://github.com/search?q={QUERY}";
                    }
                    {
                      title = "Wikipedia";
                      shortcut = "!w";
                      url = "https://en.wikipedia.org/w/index.php?search={QUERY}";
                    }
                    {
                      title = "Nix Pkgs";
                      shortcut = "!nix";
                      url = "https://search.nixos.org/packages?query={QUERY}";
                    }
                    {
                      title = "Crates";
                      shortcut = "!cr";
                      url = "https://crates.io/search?q={QUERY}";
                    }
                    {
                      title = "Maps";
                      shortcut = "!m";
                      url = "https://www.openstreetmap.org/search?query={QUERY}";
                    }
                    {
                      title = "Perplexity";
                      shortcut = "!ai";
                      url = "https://www.perplexity.ai/search?q={QUERY}";
                    }
                  ];
                }
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
      ]; # end pages
    }; # end settings
  }; # end services.glance
}
