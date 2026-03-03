{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    mcsr-nixos,
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    mcsrPkgs = mcsr-nixos.packages.x86_64-linux;
    init = pkgs.writeText "init.lua" (''
        package.path = package.path .. ";${mcsrPkgs.waywork}/?.lua"
        local programs = { ninjabrain_bot = "${pkgs.lib.getExe mcsrPkgs.ninjabrain-bot}", }
        local files = { eye_overlay = "${./eye-overlay.png}", }
      ''
      + builtins.readFile ./waywall.lua);
  in
    with pkgs; {
      devShells.x86_64-linux.default = mkShell {
        packages = [waywall];
        shellHook = ''
          mkdir -p ~/.config/waywall
          ln -sf ${init} ~/.config/waywall/init.lua
        '';
      };
    };
}
