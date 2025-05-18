{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
  };

  outputs =
    {
      self,
      home-manager,
      nix-darwin,
      flake-parts,
      nixpkgs,
      ...
    }@inputs:
    {
      darwinConfigurations.work = nix-darwin.lib.darwinSystem (
        let
          specialArgs = {
            inherit inputs;
            email = "samuel.varga@sap.com";
            gpgKey = "7FF62D2D";
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
              home-manager.users.${specialArgs.home.user} = import ./home-manager/default.nix;
              users.users.${specialArgs.home.user}.home = specialArgs.home.homeDirectory;
            }
          ];
        }
      );
      darwinConfigurations.home = nix-darwin.lib.darwinSystem (
        let
          specialArgs = {
            inherit inputs;
            email = "sam@varga.sh";
            gpgKey = "73266EE4";
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
              home-manager.users.${specialArgs.home.user} = import ./home-manager/default.nix;
              users.users.${specialArgs.home.user}.home = specialArgs.home.homeDirectory;
            }
          ];
        }
      );
    }
    // (flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        allSystems,
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [
          inputs.devshell.flakeModule
        ];
        flake = { };
        systems = [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ];
        perSystem =
          {
            pkgs,
            system,
            lib,
            ...
          }:
          {
            devshells = {
              c = import ./devShells/c.nix pkgs;
              lua = import ./devShells/lua.nix pkgs;
              nix = import ./devShells/nix.nix pkgs;
              node23 = import ./devShells/node23.nix pkgs;
              node24 = import ./devShells/node24.nix pkgs;
              php = import ./devShells/php.nix pkgs;
              pnpm = import ./devShells/pnpm.nix pkgs;
              ruby = import ./devShells/ruby.nix pkgs;
              terraform = import ./devShells/terraform.nix pkgs;
              vue = import ./devShells/vue.nix pkgs;
            };
          };
      }
    ));
}
