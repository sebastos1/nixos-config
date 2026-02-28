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
    keylist = {
      url = "github:sebastos1/keylist";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zlaunch.url = "github:zortax/zlaunch/0.5.0";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-gaming,
    nixcord,
    nix-your-shell,
    keylist,
    zlaunch,
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
