{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    bat
    eza
    fzf
    grc
    tlrc
  ];

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
      ls = "eza --icons=always";
      ll = "eza --icons=always -l";
      la = "eza --icons=always -la";
      tree = "eza --icons=always --tree";
      cat = "bat --paging=never --theme=ansi";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#seb";
      copy = "xclip -selection clipboard";
      ssh = "kitty +kitten ssh";
      music = "ncmpcpp"; # I can NOT remember this sequence of letters
    };
    functions = {
      fish_greeting = "";
    };
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
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
      {
        name = "colored-man-pages";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "colored_man_pages.fish";
          rev = "f885c2507128b70d6c41b043070a8f399988bc7a";
          sha256 = "ii9gdBPlC1/P1N9xJzqomrkyDqIdTg+iCg0mwNVq2EU=";
        };
      }
    ];
    interactiveShellInit = ''
      # make fish work nicely with nix shells
      nix-your-shell fish | source
      # direnv
      direnv hook fish | source
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  home.file.".config/starship.toml".source = ./starship.toml;
}
