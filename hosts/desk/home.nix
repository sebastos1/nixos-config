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
  ];
in
{
  imports = mkImports ../../home imports;
}
