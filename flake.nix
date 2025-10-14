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
    nix-your-shell = {
      url = "github:MercuryTechnologies/nix-your-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-gaming,
    nixcord,
    nix-your-shell,
  } @ attrs: {
    nixosConfigurations.seb = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            backupFileExtension = "backup";
            users.seb = import ./home.nix;
            extraSpecialArgs = attrs;
            sharedModules = [
              nixcord.homeModules.nixcord
            ];
          };
        }
      ];
    };
  };
}
