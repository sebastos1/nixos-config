{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-fhs;
    extensions = [
      "nix"
      "toml"
      "rust"
      "charmed-icons"
      "lua"
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

      language_models = {
        open_router = {
          api_url = "https://openrouter.ai/api/v1";
          available_models = [
            {
              name = "deepseek/deepseek-r1:free";
              display_name = "DeepSeek R1 (Free)";
              max_tokens = 64000;
              supports_tools = true;
            }
            {
              name = "deepseek/deepseek-r1-distill-llama-70b:free";
              display_name = "DeepSeek R1 Distill 70B (Free)";
              max_tokens = 64000;
              supports_tools = true;
            }
          ];
        };
      };

      agent = {
        default_model = {
          provider = "openrouter";
          model = "deepseek/deepseek-r1:free";
        };
      };
    };
  };
}
