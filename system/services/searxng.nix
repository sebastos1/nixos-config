{ pkgs, ... }:
{
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    redisCreateLocally = true;
    settings = {
      server = {
        bind_address = "::";
        port = 6767;
        secret_key = "devkey";
        image_proxy = true;
        method = "GET";
        # limiter = true;
      };

      general = {
        instance_name = "searcher";
        enable_metrics = false;
      };

      search = {
        safe_search = 0;
        autocomplete_min = 2;
        autocomplete = "duckduckgo";
        favicon_resolver = "duckduckgo";
        formats = [
          "html"
          "json" # for llm
        ];
      };

      ui = {
        static_use_hash = true;
        query_in_title = false;
        infinite_scroll = true;
        default_locale = "en";
        hotkeys = "vim";
        url_formatting = "full";
        # search_on_category_select = false;
      };

      outgoing = {
        request_timeout = 5.0;
        max_request_timeout = 15.0;
      };

      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Tor check plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];
    };
  };
}
