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
    {
      darwinConfigurations."sams-Mac-mini" = nix-darwin.lib.darwinSystem {
        modules = [
          ./nix-darwin
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sam = import ./home-manager/default.nix;

            # Why did I need this?
            users.users.sam.home = "/Users/sam";
          }
        ];
      };
    };
}
