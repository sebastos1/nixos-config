{ mkImports, ... }:
let
  imports = [
    /desktop
    /cli
    /cli/tools.nix
    /editors/zed.nix
    /browser/brave.nix
    /apps
    /apps/minecraft
    /apps/music.nix
    /browser/zen.nix
    /ai
    /editors/helix.nix
  ];
in
{
  imports = mkImports ../../home imports;
}
