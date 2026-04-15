{
  nixpkgs,
  username,
  inputs,
  systemModules,
  ...
}:
let
  mkImports = base: paths: map (p: base + p) paths;

  mkSystem =
    name:
    nixpkgs.lib.nixosSystem {
      specialArgs = inputs // {
        hostProfile = name;
        theme = import ./system/theme.nix;
        inherit
          inputs
          username
          mkImports
          ;
      };
      modules = systemModules ++ [
        ./system
        ./hosts/${name}
      ];
    };

  mkSystems =
    names:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = mkSystem name;
      }) names
    );
in
{
  inherit mkSystems mkImports;
}
