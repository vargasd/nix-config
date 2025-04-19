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
  };

  outputs =
    {
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    {
      darwinConfigurations.work = nix-darwin.lib.darwinSystem (
        let
          user = "I763291";
        in
        {
          specialArgs = inputs // {
            inherit user;
          };
          modules = [
            ./nix-darwin
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import ./home-manager/default.nix {
                user = user;
                email = "samuel.varga@sap.com";
                gpgKey = "7FF62D2D";
              };
              users.users.${user}.home = "/Users/${user}";
            }
          ];
        }
      );
      darwinConfigurations.home = nix-darwin.lib.darwinSystem (
        let
          user = "sam";
        in
        {
          specialArgs = inputs // {
            inherit user;
          };
          modules = [
            ./nix-darwin
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import ./home-manager/default.nix {
                user = user;
                email = "sam@varga.sh";
                gpgKey = "9360638973266";
              };
              users.users.${user}.home = "/Users/${user}";
            }
          ];
        }
      );
    };
}
