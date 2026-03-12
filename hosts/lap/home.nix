{mkImports, ...}: let
  imports = [
    /desktop
    /cli
    /cli/tools.nix
    /editors/zed.nix
    /browser/brave.nix
  ];
in {
  imports = mkImports ../../home imports;
}
