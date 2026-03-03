{
  description = "system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    nixcord.url = "github:KaylorBen/nixcord";

    keylist = {
      url = "github:sebastos1/keylist";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcsr-nixos = {
      url = "https://git.uku3lig.net/uku/mcsr-nixos/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixcord,
    ...
  } @ attrs: let
    mkSystem = name: {user}:
      nixpkgs.lib.nixosSystem {
        specialArgs = attrs;
        system = "x86_64-linux";
        modules = [
          ./nixos
          ./nixos/${name}
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              backupFileExtension = "backup";
              users.${user} = {
                imports = [
                  ./home
                  ./home/hosts/${name}.nix
                ];
              };
              extraSpecialArgs = attrs // {hostProfile = name;};
              sharedModules = [nixcord.homeModules.nixcord];
            };
          }
        ];
      };
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    # each setup expects a nixos/<name> and home/hosts/<name>
    nixosConfigurations = builtins.mapAttrs mkSystem {
      desk = {user = "seb";};
      lap = {user = "seb";};
      server = {user = "dio";}; # servertop
    };
  };
}
