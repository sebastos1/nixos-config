{
  outputs =
    {
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    let
      username = "seb";
      hosts = [
        "homeserver"
        "desk"
        "lap"
      ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
      {
        systems = [ "x86_64-linux" ];

        imports = [
          inputs.terranix.flakeModule
        ];

        flake =
          let
            lib = import ./lib.nix {
              inherit inputs username;
              nixosModules = with inputs; [
                agenix.nixosModules.default
                home-manager.nixosModules.home-manager
                microvm.nixosModules.host
                disko.nixosModules.disko
                impermanence.nixosModules.impermanence
              ];
              homeModules = with inputs; [
                nixcord.homeModules.nixcord
                stylix.homeModules.stylix
                zen-browser.homeModules.beta
              ];
            };
          in
          {
            nixosConfigurations = lib.mkHosts hosts // {
              installer = nixpkgs.lib.nixosSystem {
                system = [ "x86_64-linux" ];
                modules = [ ./installer.nix ];
              };
            };
          };

        perSystem =
          {
            pkgs,
            lib,
            ...
          }:
          {
            formatter = pkgs.nixfmt-tree;
            devShells.default = pkgs.mkShell {
              packages = [ inputs.agenix.packages.${pkgs.system}.default ];
            };

            # dns for servers
            terranix.terranixConfigurations.dns = {
              terraformWrapper.package = pkgs.opentofu;
              extraArgs = {
                dns = lib.mapAttrs (_: host: {
                  inherit (host.config.server.dns) tunnelId allServices;
                }) (lib.filterAttrs (_: host: host.config.server.dns.enable or false) self.nixosConfigurations);
              };
              modules = [ ./system/server/dns/terra.nix ];
            };
          };
      }
    );

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    agenix.url = "github:ryantm/agenix";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
  };
}
