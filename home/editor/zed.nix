{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-fhs;
    extensions = [
      "nix"
      "toml"
      "charmed-icons"
      "lua"
    ];
    extraPackages = with pkgs; [
      nil
      nixd
    ];
    userSettings = {
      # foundational
      session.trust_all_worktrees = true;
      journal.hour_format = "hour24";
      auto_update = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      load_direnv = "shell_hook";
      # visual
      icon_theme = "Warm Charmed Icons";
      ui_font_family = lib.mkForce config.stylix.fonts.monospace.name;
      title_bar = {
        show_onboarding_banner = false;
      };
      toolbar.quick_actions = false;
      project_panel = {
        dock = "right";
        bold_folder_labels = true;
        hide_root = true;
        auto_fold_dirs = false;
        indent_guides.show = "never";
      };
      tabs = {
        file_icons = true;
        git_status = true;
        show_diagnostics = "all";
      };
      tab_bar.show_nav_history_buttons = false;
      # editor
      # vim_mode = true;
      # relative_line_numbers = true;
      drag_and_drop_selection.enabled = false;
      extend_comment_on_newline = false;
      indent_guides.coloring = "indent_aware"; # woke editor :D
      colorize_brackets = true;
      soft_wrap = "editor_width";
      gutter = {
        runnables = false;
        folds = false;
        min_line_number_digits = 0;
      };
      sticky_scroll.enabled = true;
      scroll_beyond_last_line = "off";
      # bottom and panels
      outline_panel.dock = "right";
      collaboration_panel.button = false;
      search.button = false;
      debugger.button = false;
      terminal.button = false;
      agent.button = false;
      git_panel = {
        button = false;
        status_style = "label_color";
      };
      notification_panel = {
        dock = "left";
        button = false;
      };
      line_indicator_format = "short";
      # todo: completions, snippets, inlines, inlay hints
      # https://zed.dev/docs/visual-customization#editor-inlay-hints
    };
  };

  programs.fish.shellAliases = {
    zed = "zeditor";
  };
}
