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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixcord,
    ...
  } @ attrs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations = {
      desk = nixpkgs.lib.nixosSystem {
        specialArgs = attrs;
        system = "x86_64-linux";
        modules = [
          ./nixos/config.nix
          ./nixos/desk
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              backupFileExtension = "backup";
              users.seb = import ./home;
              extraSpecialArgs = attrs;
              sharedModules = [
                nixcord.homeModules.nixcord
              ];
            };
          }
        ];
      };
    };
  };
}
