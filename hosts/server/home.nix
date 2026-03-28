{
  pkgs,
  mkImports,
  ...
}: let
  imports = [
    /cli
  ];
in {
  imports = mkImports ../../home imports;
  home.packages = with pkgs; [
    lnav
    lazydocker
  ];

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };
}
