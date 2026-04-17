{ pkgs, lib, ... }:
{
  imports = [
    ./git.nix
    ./network.nix
    ./system.nix
  ];

  home.packages = with pkgs; [
    eza # ls
    less # paging for bat
    ripgrep # grep
    fd # find
    grc # fish wants this
    tealdeer # tldr
  ];

  # cat
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batman
      batpipe
    ];
    config = {
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
      find = "fd";
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;

    # make it quieter
    silent = true;
    config.hide_env_diff = true;
  };

  # stay in fish
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

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      # add_newline = false;
      format = lib.concatStrings [
        "$directory"

        "$git_branch"
        "$git_status"
        "$git_metrics"

        "$package"

        "$fill"

        "$status"
        "$cmd_duration"
        "$jobs"

        "$line_break"

        "$username"
        "$hostname"
        "$container"
        "$nix_shell"
        "$character"
      ];
      username = {
        aliases."root" = "󰱯";
        format = "[$user]($style bold)";
        show_always = true;
        style_user = "fg:green";
        style_root = "fg:red";
      };
      hostname = {
        ssh_only = true;
        format = "@[$hostname](fg:green)";
      };
      container = {
        format = "[ $symbol $name]($style)";
        style = "fg:base";
        symbol = "󱋩";
      };
      nix_shell = {
        format = " ❄️";
      };
      character = {
        error_symbol = " [\\$](bold red)";
        success_symbol = " [\\$](bold green)";
      };
      fill = {
        symbol = " ";
      };
      directory = {
        format = "$path[$read_only]($read_only_style)";
        style = "fg:cyan";
        read_only = "(ro)";
        read_only_style = "bold fg:red";
        truncation_length = 100;
        truncation_symbol = "󰊢 ";
      };
      git_branch = {
        format = "[  $branch]($style)";
        style = "fg:green";
      };
      git_status = {
        format = "($all_status$ahead_behind)";
      };
      git_metrics = {
        disabled = false;
        added_style = "bold fg:black bg:green";
        deleted_style = "bold fg:black bg:red";
        format = "([+$added]($added_style)[-$deleted]($deleted_style) )";
      };
      package = {
        format = " [ $version]($style)";
        style = "fg:yellow";
        version_format = "$raw";
      };
      status = {
        format = "$symbol";
        map_symbol = true;
        pipestatus = false;
        style = "fg:red";
        success_symbol = "";
        symbol = "[ $status]($style)";
        not_executable_symbol = "[ $common_meaning]($style)";
        not_found_symbol = "[󰩌 $common_meaning]($style)";
        sigint_symbol = "[ $signal_name]($style)";
        signal_symbol = "[⚡ $signal_name]($style)";
      };
      cmd_duration = {
        format = "[ $duration]($style)";
        # min_time = 2500;
        min_time_to_notify = 60000;
        show_notifications = false;
      };
      jobs = {
        format = " $symbol $number";
        symbol = "󰣖";
      };
    };
  };
}
