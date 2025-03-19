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

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions/7772d48f5a728af51cd8ac85be5b124e2da0feac?dir=pkgs/firefox-addons";
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
      darwinConfigurations."sams-Mac-mini" = nix-darwin.lib.darwinSystem (

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
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import ./home-manager/default.nix user;

              users.users.${user}.home = "/Users/${user}";
            }
          ];
        }
      );
    };
}
