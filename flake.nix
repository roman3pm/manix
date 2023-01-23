{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, nixpkgs-master, home-manager, nix-index-database, ... }:
    let
      system = "x86_64-linux";
      overlays = import ./overlays.nix inputs system;
    in {
    nixosConfigurations = {
      "roz-pc" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs;
        modules = [
          ./configuration.nix
          {
            nixpkgs = {
              overlays = [ overlays ];
              config.allowUnfree = true;
            };
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.roz = import ./home.nix;
              sharedModules = [
                nix-index-database.hmModules.nix-index
              ];
            };
          }
        ];
      };
    };
  };
}
