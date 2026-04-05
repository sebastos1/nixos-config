# todo
# https://raw.githubusercontent.com/wokenlex/infobubble-support/refs/heads/main/Sources/all.sources.rss.yaml

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
