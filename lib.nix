{
  inputs,
  username,
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
          ;
      };
      modules = nixosModules ++ [
        ./system
        ./hosts/${name}
        ./hosts/${name}/hardware.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            users.${username}.imports = [
              ./home
            ];
            extraSpecialArgs = {
              inherit inputs username mkImports;
              hostProfile = name;
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
