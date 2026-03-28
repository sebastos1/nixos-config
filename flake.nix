{
  description = "system config";

  outputs = {
    nixpkgs,
    agenix,
    home-manager,
    stylix,
    nixcord,
    zen-browser,
    ...
  } @ inputs: let
    mkImports = base: paths: map (p: base + p) paths;
    mkSystem = name: {user}:
      nixpkgs.lib.nixosSystem {
        specialArgs =
          inputs
          // {
            inputs = inputs;
            username = user;
            mkImports = mkImports;
          };
        system = "x86_64-linux";
        modules = [
          ./system
          ./hosts/${name}
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              backupFileExtension = "backup";
              users.${user} = {
                imports = [
                  ./home
                  ./hosts/${name}/home.nix
                ];
              };
              extraSpecialArgs =
                inputs
                // {
                  hostProfile = name;
                  username = user;
                  mkImports = mkImports;
                };
              sharedModules = [
                nixcord.homeModules.nixcord
                stylix.homeModules.stylix
                zen-browser.homeModules.beta
              ];
            };
          }
        ];
      };
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      packages = [
        agenix.packages.x86_64-linux.default
      ];
    };

    nixosConfigurations = builtins.mapAttrs mkSystem {
      desk = {
        user = "seb";
      };
      lap = {
        user = "seb";
      };
      server = {
        user = "dio";
      }; # servertop
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    keylist = {
      url = "github:sebastos1/keylist";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nixcord.url = "github:KaylorBen/nixcord";

    mcsr-nixos = {
      url = "https://github.com/sebastos1/mcsr-nixos/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    ironbar = {
      url = "github:sebastos1/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ello-plymouth = {
      url = "github:sebastos1/ello-plymouth";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
