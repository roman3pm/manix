{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nur.url = "github:nix-community/NUR";
    gen-nvim = {
      url = "github:David-Kunz/gen.nvim";
      flake = false;
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;
      overlays = [
        (import ./overlays inputs system)
        inputs.nur.overlays.default
      ];
      findModules =
        dir:
        builtins.concatLists (
          builtins.attrValues (
            builtins.mapAttrs (
              name: type:
              if type == "regular" then
                [
                  {
                    name = builtins.elemAt (builtins.match "(.*)\\.nix" name) 0;
                    value = dir + "/${name}";
                  }
                ]
              else if (builtins.readDir (dir + "/${name}")) ? "default.nix" then
                [
                  {
                    inherit name;
                    value = dir + "/${name}";
                  }
                ]
              else
                findModules (dir + "/${name}")
            ) (builtins.readDir dir)
          )
        );
    in
    {
      nixosModules = builtins.listToAttrs (findModules ./modules);

      nixosProfiles = builtins.listToAttrs (findModules ./profiles);

      nixosRoles = import ./roles;

      nixosConfigurations =
        let
          hosts = builtins.attrNames (builtins.readDir ./machines);
          mkHost =
            hostName:
            lib.nixosSystem rec {
              inherit system;
              specialArgs = {
                inherit inputs;
              };
              modules = builtins.attrValues self.nixosModules ++ [
                inputs.agenix.nixosModules.default
                inputs.nix-index-database.nixosModules.nix-index
                inputs.nix-flatpak.nixosModules.nix-flatpak

                (import (./machines + "/${hostName}"))
                {
                  inherit hostName;
                  nix.registry.n.flake = inputs.nixpkgs;
                  nixpkgs = {
                    inherit overlays;
                    config.allowUnfree = true;
                    config.allowAliases = false;
                  };
                  environment.systemPackages = [ inputs.agenix.packages.${system}.default ];
                }

                inputs.home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = specialArgs;
                  };
                }
              ];
            };
        in
        lib.genAttrs hosts mkHost;
    };
}
