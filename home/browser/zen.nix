{ config, ... }:
{
  programs.zen-browser =
    let
      # extensions: https://github.com/0xc000022070/zen-browser-flake?tab=readme-ov-file#extensions
      mkExtensionSettings = builtins.mapAttrs (
        _: pluginId: {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
          installation_mode = "force_installed";
        }
      );
    in
    {
      enable = true;

      # Enabled Zen Mods:
      # - Animations Plus
      # - Better Active Tab
      # - Better Unloaded Tabs
      # - Cleaned URL bar
      # - Lean
      # - No Gaps
      # - SuperPins

      policies = {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true; # save webs for later reading
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        ExtensionSettings = mkExtensionSettings {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
          "uBlock0@raymondhill.net" = "ublock-origin";
        };
      };

      profiles."default" = {
        settings = {
          zen = {
            urlbar.behavior = "float";
            view = {
              compact = {
                enable-at-startup = false;
                hide-toolbar = false;
                toolbar-flash-popup = false;
              };
              use-single-toolbar = false;
              window.scheme = 0;
            };
            welcome-screen.seen = true;
            workspaces.continue-where-left-off = true;
          };
          browser = {
            tabs.warnOnClose = false;
            # download.panel.shown = false;
          };
        };
        containersForce = true;
        containers = {
          "Personal" = {
            color = "purple";
            icon = "fingerprint";
            id = 1;
          };
        };
        spacesForce = true;
        spaces =
          let
            containers = config.programs.zen-browser.profiles."default".containers;
          in
          {
            "Personal" = {
              id = "787d0fd7-5d70-4dbc-801d-3dfae851658b";
              container = containers."Personal".id;
              position = 1000;
              theme = {
                type = "gradient";
                colors = [
                  {
                    red = 97;
                    green = 122;
                    blue = 184;
                    algorithm = "floating";
                  }
                  {
                    red = 96;
                    green = 184;
                    blue = 174;
                    algorithm = "complementary";
                  }
                ];
                opacity = 0.4;
                texture = 0.5;
              };
            };
          };
      };
    };
}
