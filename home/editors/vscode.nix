{ pkgs, ... }:
{
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
        "workbench.iconTheme" = "material-icon-theme";
        "editor.inlayHints.enabled" = "offUnlessPressed";
      };
      extensions = with pkgs.vscode-extensions; [
        tamasfe.even-better-toml
        bbenoist.nix
        pkief.material-icon-theme
      ];
    };
  };
}
