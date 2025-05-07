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
      darwinConfigurations.work = nix-darwin.lib.darwinSystem (
        let
          specialArgs = {
            inherit inputs;
            user = "I763291";
            email = "samuel.varga@sap.com";
            gpgKey = "7FF62D2D";
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
              home-manager.users.${specialArgs.user} = import ./home-manager/default.nix;
              users.users.${specialArgs.user}.home = "/Users/${specialArgs.user}";
            }
          ];
        }
      );
      darwinConfigurations.home = nix-darwin.lib.darwinSystem (
        let
          specialArgs = {
            inherit inputs;
            user = "sam";
            email = "sam@varga.sh";
            gpgKey = "9360638973266";
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
              home-manager.users.${specialArgs.user} = import ./home-manager/default.nix;
              users.users.${specialArgs.user}.home = "/Users/${specialArgs.user}";
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
          config.allowUnfree = true;
        };
      in
      {
        devShells = {
          c = import ./devShells/c.nix pkgs;
          lua = import ./devShells/lua.nix pkgs;
          nix = import ./devShells/nix.nix pkgs;
          node23 = import ./devShells/node23.nix pkgs;
          php = import ./devShells/php.nix pkgs;
          ruby = import ./devShells/ruby.nix pkgs;
          terraform = import ./devShells/terraform.nix pkgs;
          vue = import ./devShells/vue.nix pkgs;
        };
      }
    ));
}
