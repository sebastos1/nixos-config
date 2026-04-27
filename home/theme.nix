{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  theme = config.theme;
in
{
  options.theme = {
    enable = mkEnableOption "theme";

    # enabled by ./desktop
    client = mkOption {
      type = types.bool;
      default = false;
      description = "disable on servers (dconf, fontconfig)";
    };

    # everforest-dark-hard, everforest-dark-medium, onedark, gruvbox-dark-hard, gruvbox-material-dark-hard, solarized-dark
    # lights: gruvbox-light-medium, solarized-light
    # $ ls /nix/store/*base16-schemes*/share/themes/ | grep gruv
    name = mkOption {
      type = types.str;
      default = "gruvbox-material-dark-hard";
      description = "theme to use (from base16 package)";
    };

    light = mkOption {
      type = types.bool;
      default = false;
      description = "enable light theme";
    };

    fonts =
      let
        fontType = types.submodule {
          options = {
            package = mkOption { type = types.package; };
            name = mkOption { type = types.str; };
          };
        };
      in
      {
        sizes = {
          terminal = mkOption {
            type = types.int;
            default = 14;
          };
          applications = mkOption {
            type = types.int;
            default = 12;
          };
          desktop = mkOption {
            type = types.int;
            default = 10;
          };
        };

        monospace = mkOption {
          type = fontType;
          default = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrainsMono Nerd Font";
          };
        };

        sansSerif = mkOption {
          type = fontType;
          default = {
            package = pkgs.ibm-plex;
            name = "IBM Plex Sans";
          };
        };

        serif = mkOption {
          type = fontType;
          default = {
            package = pkgs.ibm-plex;
            name = "IBM Plex Serif";
          };
        };
      };
  };

  config =
    let
      polarity = if theme.light then "light" else "dark";
    in

    mkIf theme.enable {
      stylix = {
        enable = true;
        overlays.enable = false;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme.name}.yaml";
        inherit polarity;
        targets.zen-browser.profileNames = [ "default" ];
        targets.gtk.enable = theme.client;
      };

      dconf.settings = mkIf theme.client (mkForce {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-${polarity}";
          gtk-theme = "adw-gtk3-${polarity}";
        };
      }) otherwise { };

      stylix.fonts = with pkgs; {
        inherit (theme.fonts)
          monospace
          sansSerif
          serif
          sizes
          ;
        emoji = {
          package = twitter-color-emoji;
          name = "Twitter Color Emoji";
        };
      };

      # fallback fonts are enabled on clients
      home.packages =
        with pkgs;
        mkIf theme.client [
          # font-awesome
          noto-fonts # latin, greek, cyrillic, etc
          noto-fonts-cjk-sans # chinese, japanese, korean
        ];

      fonts.fontconfig = mkIf theme.client {
        enable = true;
        antialiasing = true;
        hinting = "slight";
        subpixelRendering = "none";
        defaultFonts = {
          monospace = [
            "Noto Sans CJK"
            "Twitter Color Emoji"
          ];
          sansSerif = [
            "Noto Sans CJK"
            "Twitter Color Emoji"
          ];
          serif = [
            "Noto Serif CJK"
            "Twitter Color Emoji"
          ];
          emoji = [
            "Twitter Color Emoji"
          ];
        };
      };

      # static for now
      home.pointerCursor = mkIf theme.client {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 20;
        gtk.enable = true;
      };
    };
}
