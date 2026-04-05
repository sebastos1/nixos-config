{ pkgs, ... }:
{
  services.forgejo = {
    enable = true;
    package = pkgs.forgejo; # default is 3 versions behind bruh
    database = {
      type = "postgres";
      createDatabase = true;
    };
    lfs.enable = true;

    settings = {
      DEFAULT.APP_NAME = "sjallabong git";

      server = {
        DOMAIN = "git.shlb.ng"; # todo
        ROOT_URL = "https://git.shlb.ng";
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3000;
        # START_SSH_SERVER = true;
        # BUILTIN_SSH_SERVER_USER = "git";
        # SSH_DOMAIN = "git.shlb.ng";
        # SSH_LISTEN_PORT = 2222;
      };

      # service = {
      #   REGISTER_EMAIL_CONFIRM = true;
      #   # EMAIL_DOMAIN_ALLOWLIST = ""; # hmm

      #   DEFAULT_KEEP_EMAIL_PRIVATE = true;
      #   ALLOW_ONLY_INTERNAL_REGISTRATION = false; # oauth i guess?

      #   ENABLE_CAPTCHA = true;
      #   CAPTCHA_TYPE = "image";
      # };

      # actions = {
      #   ENABLED = true;
      #   DEFAULT_ACTIONS_URL = "https://github.com";
      # };

      repository = {
        DEFAULT_PRIVATE = "private";
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
        DEFAULT_PUSH_CREATE_PRIVATE = true;
        DEFAULT_BRANCH = "main";
        # PREFERRED_LICENSES =
      };

      indexer = {
        REPO_INDEXER_ENABLED = true;
        REPO_INDEXER_EXCLUDE = "*.min.js,*.min.css";
      };

      ui = {
        # THIS IS PEAKKKK TODODTOTDOOTDOTDOTDOTDO
        # REACTIONS: All available reactions users can choose on issues/PRs and comments. Values can be emoji aliases (😄) or Unicode emojis. For custom reactions, add a tightly cropped square image to public/assets/img/emoji/reaction_name.png.

        SHOW_USER_EMAIL = false;
        ONLY_SHOW_RELEVANT_REPOS = true;
      };

      # ANYWAY
      #https://forgejo.org/docs/next/admin/config-cheat-sheet/

      other = {
        # SHOW_FOOTER_VERSION = false;
      };

      # federation = {
      #   ENABLED = true;
      # };

      # mailer todo ?

      # metyrics ? lotta todo here please eignore
    };
  };

  # runner todo
}
