{mkImports, ...}: let
  imports = [
    /desktop
    /desktop/niri
    /cli
    /cli/tools.nix
    /editors/zed.nix
    /browser/brave.nix
    /apps
    /apps/minecraft
    /apps/music.nix
  ];
in {
  imports = mkImports ../../home imports;
}
