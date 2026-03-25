{...}: {
  programs.git = {
    enable = true;
    # package = pkgs.gitFull;
    settings = {
      core.askpass = "";
      credential.helper = "libsecret";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = "true"; # must have
      rebase = {
        autoStash = true;
        autosquash = true;
      };
      fetch = {
        prune = true; # remove remote tracking refs
        # prunetags = true; # remove tags
      };
      commit.verbose = true; # show diff
      diff = {
        colorMoved = "default";
        algorithm = "histogram";
      };
      rerere.enabled = true; # remember resolved conflicts
      merge.conflictStyle = "zdiff3";
      log.date = "relative";
      color = {
        status = "auto";
        branch = "auto";
        interactive = "auto";
      };
      alias = {
        a = "add .";
        s = "status -sb";
        c = "commit -v";
        l = "log --oneline --graph --decorate";
        undo = "reset HEAD~1 --mixed";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      hyperlinks = true;
      side-by-side = true;
    };
  };

  programs.lazygit = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      git.pagers = [
        {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        }
      ];
    };
  };
}
