{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      nix-darwin,
    }:
    let
      user = "sam";
    in
    {
      darwinConfigurations."sams-Mac-mini" = nix-darwin.lib.darwinSystem {
        modules = [
          ./nix-darwin
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./home-manager/default.nix user;

            users.users.${user}.home = "/Users/${user}";
          }
        ];
      };
    };
}
