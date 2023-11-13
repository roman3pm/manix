{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      overlays = [
        (import ./overlays.nix inputs system)
        inputs.nur.overlay
      ];
      findModules = dir:
        builtins.concatLists (builtins.attrValues (builtins.mapAttrs
          (name: type:
            if type == "regular" then [{
              name = builtins.elemAt (builtins.match "(.*)\\.nix" name) 0;
              value = dir + "/${name}";
            }] else if (builtins.readDir (dir + "/${name}")) ? "default.nix" then [{
              inherit name;
              value = dir + "/${name}";
            }] else findModules (dir + "/${name}"))
          (builtins.readDir dir)
        ));
    in
    {
      nixosModules = builtins.listToAttrs (findModules ./modules);

      nixosProfiles = builtins.listToAttrs (findModules ./profiles);

      nixosRoles = import ./roles;

      nixosConfigurations = with nixpkgs.lib;
        let
          hosts = builtins.attrNames (builtins.readDir ./machines);
          mkHost = name:
            nixosSystem rec {
              inherit system;
              specialArgs = { inherit inputs; };
              modules = __attrValues self.nixosModules ++ [
                inputs.agenix.nixosModules.default
                {
                  nixpkgs = {
                    overlays = overlays;
                    config.allowUnfree = true;
                  };
                }
                ./configuration.nix
                { device = name; }
                (import (./machines + "/${name}"))
                inputs.home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users.roz = import ./home.nix;
                    extraSpecialArgs = specialArgs;
                  };
                }
              ];
            };
        in
        genAttrs hosts mkHost;
    };
}
