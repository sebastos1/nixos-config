{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rustup
    clang

    pastel
    xcolor

    alejandra

    lazygit
    delta
  ];

  programs.git = {
    enable = true;
    settings = {
      core.askpass = "";
      credential.helper = "store";
      push.autoSetupRemote = true;
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor;
    profiles.default = {
      userSettings = {
        "editor.fontFamily" = "JetBrains Mono Nerd Font";
        "editor.fontLigatures" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = true;
        "files.trimTrailingWhitespace" = true;
        "editor.wordWrap" = "on";
        "telemetry.telemetryLevel" = "off";
        "update.mode" = "none";
        "editor.minimap.enabled" = false;
        "editor.linkedEditing" = true;
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = true;
        "workbench.colorTheme" = "Gruvbox Dark Hard";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.inlayHints.enabled" = "offUnlessPressed";
      };
      extensions = with pkgs.vscode-extensions; [
        tamasfe.even-better-toml
        jdinhlife.gruvbox
        bbenoist.nix
        pkief.material-icon-theme
      ];
    };
  };
}
