{
  pkgs,
  hostProfile,
  username,
  ...
}:
{
  imports = [
    ./git
  ];

  users.users.${username}.packages = with pkgs; [
    eza # ls
    less # paging for bat
    ripgrep # grep
    fd # find
    grc # fish wants this
    tealdeer # tldr

    starship
    bat
    bat-extras.batman
    bat-extras.batpipe

    atuin # cmd history

    zoxide # cd
    fzf # peak

    pay-respects # thefuck

    nix-your-shell # stay in fish
    direnv

    # todo
    nix-output-monitor
    procs
    duf
    dust
    btop
    fastfetch

    ouch # zips
    p7zip # zip
    ffmpeg # video
    zathura # pdf
    imagemagick # image biz
    jq # json
    resvg # svg
    glow # markdown
    pastel
  ];

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  hjem.users.${username}.files = {
    ".config/starship.toml".source = ./starship.toml;

    ".config/bat/config".text = ''
      --pager=less -FR
      --style=plain
    '';

    ".config/atuin/config.toml".text = ''
      search_mode = "fuzzy"
      filter_mode = "global"
      show_preview = true
    '';

    ".config/direnv/direnv.toml".text = ''
      [global]
      hide_env_diff = true
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons";
      ll = "eza --icons -l";
      la = "eza --icons -la";
      tree = "eza --icons --tree";
      cd = "z";
      cat = "bat";
      cats = "bat --style=numbers,changes,header";
      grep = "rg";

      # todo
      find = "fd";
      ps = "procs";
      df = "duf";
      du = "dust";
      top = "btop";
      rebuild = "nh os switch --hostname ${hostProfile}";
      nom = "nix-output-monitor";

      unzip = "ouch decompress";
      copy = "wl-copy"; # copy < file.txt
    };
    # functions = {
    #   fish_greeting = "";
    #   fish_title = ''
    #     if set -q argv[1]
    #       echo $argv[1] (prompt_pwd)
    #     else
    #       echo (prompt_pwd)
    #     end
    #   '';
    # };
    # plugins = [
    #   {
    #     name = "autopair";
    #     src = pkgs.fishPlugins.autopair.src;
    #   }
    #   {
    #     name = "grc";
    #     src = pkgs.fishPlugins.grc.src;
    #   }
    #   {
    #     name = "sponge";
    #     src = pkgs.fishPlugins.sponge.src;
    #   }
    # ];
    interactiveShellInit = ''
      pay-respects fish --alias f | source
      zoxide init fish | source
      fzf --fish | source
      atuin init fish | source
      starship init fish | source
      direnv hook fish | source
      nix-your-shell fish | source
    '';
  };

  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  #   enableFishIntegration = true;

  #   # make it quieter
  #   silent = true;
  #   config.hide_env_diff = true;
  # };

  # auto-jump into fish
  programs.bash = {
    completion.enable = true;
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
