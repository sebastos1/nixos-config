{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ghostty

    # terminal things that idk where to put
    curl
    nh

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

    fzf
    grc # colors some commands



    file

    direnv
    nix-your-shell

    # nautilus

    #yazi previews
    ffmpeg
    poppler
    imagemagick
    p7zip
    jq
    glow
  ];

  # cat
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batman
      batpipe
    ];
  };

  # tui files
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
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
      cd = "z";
      ls = "eza --icons=always";
      ll = "eza --icons=always -l";
      la = "eza --icons=always -la";
      tree = "eza --icons=always --tree";
      cat = "bat --paging=never --theme=ansi";
      # rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#seb";
      rebuild = "nh os switch /etc/nixos --hostname seb";
      copy = "wl-copy";
      # ssh = "kitty +kitten ssh";
      music = "ncmpcpp"; # I can NOT remember this sequence of letters
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
  };
  home.file.".config/starship.toml".source = ./starship.toml;
}
