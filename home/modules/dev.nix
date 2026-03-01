{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    rustup
    clang

    pastel
    xcolor

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

  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-fhs;
    extensions = [
      "nix"
      "toml"
      "rust"
      "charmed-icons"
    ];
    extraPackages = with pkgs; [
      nil
      nixd
    ];
    userSettings = {
      # foundational
      journal.hour_format = "hour24";
      auto_update = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      # visual
      theme = "Gruvbox Dark";
      icon_theme = "Warm Charmed Icons";
      ui_font_size = 16;
      buffer_font_size = 14;
      ui_font_family = "JetBrainsMono Nerd Font";
      buffer_font_family = "JetBrainsMono Nerd Font";
      title_bar = {
        show_onboarding_banner = false;
        # show_user_menu = false;
      };
      toolbar = {
        quick_actions = false;
      };
      project_panel = {
        dock = "right";
        bold_folder_labels = true;
        # indent_size = 16;
        hide_root = true;
        auto_fold_dirs = false;
      };
      # tabs
      tabs = {
        file_icons = true;
        git_status = true;
      };
      tab_bar.show_nav_history_buttons = false;
      # editor
      base_keymap = "VSCode"; # mental debt
      vim_mode = false;
      drag_and_drop_selection.enabled = false;
      extend_comment_on_newline = false;
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };
      soft_wrap = "editor_width";
      # relative_line_numbers = true;
      format_on_save = "on";
      colorize_brackets = true;
      scrollbar = {
        show = "auto";
        git_diff = true;
      };
      gutter = {
        min_line_number_digits = 0;
        folds = false;
        runnables = false;
      };
      notification_panel.dock = "left";
      outline_panel.dock = "right";
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
        "workbench.colorTheme" = "Gruvbox Dark";
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
