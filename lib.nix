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
        inherit inputs username;
        inherit mkImports;
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
              inherit username;
              inherit mkImports;
            };
            sharedModules = sharedModules;
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
