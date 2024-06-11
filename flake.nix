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
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    gen-nvim = {
      url = "github:David-Kunz/gen.nvim";
      flake = false;
    };
    llm-nvim = {
      url = "github:huggingface/llm.nvim";
      flake = false;
    };
  };

  outputs = inputs@{ self, ... }:
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;
      overlays = [
        (import ./overlays inputs system)
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

      nixosConfigurations =
        let
          hosts = builtins.attrNames (builtins.readDir ./machines);
          mkHost = name:
            lib.nixosSystem rec {
              inherit system;
              specialArgs = { inherit inputs; };
              modules = __attrValues self.nixosModules ++ [
                inputs.agenix.nixosModules.default

                ./configuration.nix
                (import (./machines + "/${name}"))
                {
                  device = name;
                  nix.registry.n.flake = inputs.nixpkgs;
                  nixpkgs = {
                    inherit overlays;
                    config.allowUnfree = true;
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
