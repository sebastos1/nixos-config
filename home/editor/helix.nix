{
  pkgs,
  ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        line-number = "relative";
        cursorline = true;
        true-color = true;
        bufferline = "always";
        color-modes = true;
        indent-guides.render = true;

        auto-save = true;
        lsp.display-inlay-hints = true;

        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "warning";
      };

      keys = {
        normal = {
          i = "move_line_up";
          j = "move_char_left";
          k = "move_line_down";
          l = "move_char_right";
          h = "insert_mode";
        };

        select = {
          i = "extend_line_up";
          j = "extend_char_left";
          k = "extend_line_down";
          l = "extend_char_right";
          h = "insert_mode";
        };
      };
    };

    extraPackages = with pkgs; [
      marksman
      nixd
      rust-analyzer
    ];
  };
}
