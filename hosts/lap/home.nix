{ mkImports, ... }:
let
  imports = [
    /editors/zed.nix
    /browser/brave.nix
  ];
in
{
  imports = mkImports ../../home imports;
}
