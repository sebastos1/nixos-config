{pkgs, ...}: {
  home.packages = with pkgs; [
    # terminal things that idk where to put
    nh
    nix-output-monitor
    nmap
    nix-your-shell

    grc # colors some commands
    zoxide # cd
    eza # ls
    ripgrep # grep
    tealdeer # tldr
    fd # find
    httpie # curl
    ouch # zips

    duf # df
    dust # du
    btop # htop
    # bottom
    fastfetch

    # yazi
    fzf
    ffmpeg # video
    poppler # pdf
    imagemagick # image biz
    p7zip # zip
    jq # json
    resvg # svg
    glow # markdown
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };

  # tui files
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    plugins = with pkgs.yaziPlugins; {
      inherit
        git
        mediainfo
        duckdb
        ;
    };
    shellWrapperName = "y";
  };

  # cat
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batman
      batpipe
    ];
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      search_mode = "fuzzy";
      filter_mode = "global";
      show_preview = true;
    };
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "Gruvbox Material";
      window-padding-x = 12;
      window-padding-y = 12;
      window-padding-balance = true;
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      unzip = "ouch decompress";
      cd = "z";
      ls = "eza --icons=always";
      ll = "eza --icons=always -l";
      la = "eza --icons=always -la";
      tree = "eza --icons=always --tree";
      cat = "bat --paging=never --theme=ansi";
      rebuild = "nh os switch /etc/nixos --hostname desk ";
      copy = "wl-copy";
      # ssh = "kitty +kitten ssh";
      music = "ncmpcpp"; # I can NOT remember this sequence of letters
      zed = "zeditor";
    };
    functions = {
      fish_greeting = "";
      fish_title = ''
        if set -q argv[1]
          echo $argv[1] (prompt_pwd)
        else
          echo (prompt_pwd)
        end
      '';
    };
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];
    interactiveShellInit = ''
      set fzf_history_opts --disabled
      # make fish work nicely with nix shells
      nix-your-shell fish | source
      # direnv
      direnv hook fish | source
      zoxide init fish | source
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      character = {
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
      };
    };
  };
}
