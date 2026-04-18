{
  inputs,
  username,
  configPath,
  nixosModules,
  homeModules,
  ...
}:
let
  mkImports = base: paths: map (p: base + p) paths;

  mkHost =
    name:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          username
          mkImports
          configPath
          ;
      };
      modules = nixosModules ++ [
        ./system # shared system
        ./hosts/${name}
        ./hosts/${name}/hardware.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            users.${username}.imports = [
              ./home # shared home
            ];
            extraSpecialArgs = {
              inherit inputs username mkImports;
              hostProfile = name;
              configPath = configPath;
            };
            sharedModules = homeModules;
          };
        }
      ];
    };

  mkHosts = names: inputs.nixpkgs.lib.genAttrs names mkHost;
in
{
  inherit mkHosts mkImports;
}
