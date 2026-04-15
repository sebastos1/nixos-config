{
  pkgs,
  username,
  lib,
  ...
}:
let
  base = builtins.fromJSON (builtins.readFile ./zed.json);
  overrides = {
    theme = "Gruvbox Dark Hard";
    ui_font_size = 16;
    buffer_font_size = 18;
    buffer_font_family = "JetBrains Mono";
  };
  merged = lib.recursiveUpdate base overrides;
in
{
  users.users.${username}.packages = with pkgs; [
    zed-editor-fhs
    nixd
  ];

  hjem.users.${username}.files = {
    ".config/zed/settings.json".text = builtins.toJSON merged;
  };
}
