{
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      core.askpass = "";
      credential.helper = "store";
      push.autoSetupRemote = true;
    };
    extraConfig = {
      diff.colorMoved = "default";
      merge.conflictStyle = "zdiff3";
      color.ui = "auto";
      color.status = "auto";
      color.branch = "auto";
    };
    aliases = {
      s = "status -sb";
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
