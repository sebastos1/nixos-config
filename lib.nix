{
  nixpkgs,
  username,
  inputs,
  systemModules,
  sharedModules,
  ...
}:
let
  mkImports = base: paths: map (p: base + p) paths;

  mkSystem =
    name:
    nixpkgs.lib.nixosSystem {
      specialArgs = inputs // {
        hostProfile = name;
        inherit
          inputs
          username
          mkImports
          ;
      };
      modules = systemModules ++ [
        ./system
        ./hosts/${name}
        {
          home-manager = {
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            users.${username}.imports = [
              ./home
              ./hosts/${name}/home.nix
            ];
            extraSpecialArgs = inputs // {
              hostProfile = name;
              inherit username mkImports;
            };
            inherit sharedModules;
          };
        }
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
