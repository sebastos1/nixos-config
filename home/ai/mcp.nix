{ pkgs, ... }:
let
  mcp-searxng = pkgs.buildNpmPackage rec {
    pname = "mcp-searxng";
    version = "1.0.3";
    src = pkgs.fetchFromGitHub {
      owner = "ihor-sokoliuk";
      repo = "mcp-searxng";
      rev = "v${version}";
      hash = "sha256-DEZW6pG/t13I95ZmW7WyIJNfPd64d9cf55ceUyl0SAY=";
    };
    npmDepsHash = "sha256-STrntrJ4k9Gvo+kYUXw/mnC5XyKvzxy28HifCQqostU=";
    dontNpmBuild = false;
  };
in
{
  home.packages = with pkgs; [
    # mcp-nixos
    uv
  ];

  programs.mcp = {
    enable = true;
    servers = {
      # nixos = {
      #   command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
      # };
      searxng = {
        command = "${mcp-searxng}/bin/mcp-searxng";
        env.SEARXNG_URL = "http://[::1]:6767";
      };
    };
  };
}
