{
  pkgs,
  hostProfile,
  ...
}:
{
  imports = [
    ./git.nix
  ];

  home.packages = with pkgs; [
    eza # ls
    less # paging for bat
    ripgrep # grep
    fd # find

    tealdeer # tldr
    httpie # curl
    nmap

    # monitoring
    duf # df
    dust # du
    btop # htop
    fastfetch

    nh
    nix-output-monitor
  ];

  # cat
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batman
      batpipe
    ];
    config = {
      theme = "gruvbox-dark";
      pager = "less -FR";
      style = "plain";
    };
  };

  # cd
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # peak
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # cmd history
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      search_mode = "fuzzy";
      filter_mode = "global";
      show_preview = true;
    };
  };

  # thefuck
  programs.pay-respects = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };

  programs.nix-your-shell = {
    enable = true;
    enableFishIntegration = true;
  };

  # auto-jump into fish
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
      ls = "eza --icons";
      ll = "eza --icons -l";
      la = "eza --icons -la";
      tree = "eza --icons --tree";
      cd = "z";
      cat = "bat";
      cats = "bat --style=numbers,changes,header";
      copy = "wl-copy"; # copy < file.txt
      grep = "rg";
      find = "fd";

      unzip = "ouch decompress";
      rebuild = "nh os switch /etc/nixos --hostname ${hostProfile}";
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
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];
    interactiveShellInit = ''
      pay-respects fish --alias f | source
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
