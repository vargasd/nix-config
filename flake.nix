{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		nix-darwin.url = "github:LnL7/nix-darwin/master";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, nix-darwin }@inputs: {

		# Build darwin flake using:
		# $ darwin-rebuild build --flake .#sams-Mac-mini
		darwinConfigurations."sams-Mac-mini" = nix-darwin.lib.darwinSystem {
			modules = [ 
				./nix-darwin
			];
		};
	};
}
