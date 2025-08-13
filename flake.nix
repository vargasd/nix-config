{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
  };

  outputs =
    {
      home-manager,
      nix-darwin,
      flake-utils,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations.nuc = nixpkgs.lib.nixosSystem (
        let
          specialArgs = {
            inherit inputs;
            home = {
              homeDirectory = "/home/vargasd";
              user = "vargasd";
            };
            additionalConfig = { };
          };
        in
        {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${specialArgs.home.user} = import ./home-manager/default.nix;
            }
          ];
        }
      );
      darwinConfigurations.work = nix-darwin.lib.darwinSystem (
        let
          specialArgs = {
            inherit inputs;
            home = {
              homeDirectory = "/Users/I763291";
              user = "I763291";
            };
          };
        in
        {
          inherit specialArgs;
          modules = [
            ./nix-darwin
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${specialArgs.home.user} = import ./home-manager/darwin.nix;
              users.users.${specialArgs.home.user}.home = specialArgs.home.homeDirectory;
            }
          ];
        }
      );
      darwinConfigurations.home = nix-darwin.lib.darwinSystem (
        let
          specialArgs = {
            inherit inputs;
            home = {
              user = "sam";
              homeDirectory = "/Users/sam";
            };
          };
        in
        {
          inherit specialArgs;
          modules = [
            ./nix-darwin
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${specialArgs.home.user} = import ./home-manager/darwin.nix;
              users.users.${specialArgs.home.user}.home = specialArgs.home.homeDirectory;
            }
          ];
        }
      );
    }
    // (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells = {
          c = import ./devShells/c.nix pkgs;
          gcp = import ./devShells/gcp.nix pkgs;
          lua = import ./devShells/lua.nix pkgs;
          nix = import ./devShells/nix.nix pkgs;
          node24 = import ./devShells/node24.nix pkgs;
          node22 = import ./devShells/node22.nix pkgs;
          node20 = import ./devShells/node20.nix pkgs;
          php = import ./devShells/php.nix pkgs;
          pnpm = import ./devShells/pnpm.nix pkgs;
          ruby = import ./devShells/ruby.nix pkgs;
          terraform =
            let
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
            in
            import ./devShells/terraform.nix pkgs;
          vue = import ./devShells/vue.nix pkgs;
        };
      }
    ));
}
