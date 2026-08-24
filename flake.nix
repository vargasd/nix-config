{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    pkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    enhansi = {
      url = "github:vargasd/enhansi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gen-luarc = {
      url = "github:mrcjkb/nix-gen-luarc-json";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    clear-notifications = {
      url = "git+https://gist.github.com/lancethomps/a5ac103f334b171f70ce2ff983220b4f.git";
      flake = false;
    };

    pinentry-fuzzel = {
      url = "github:WingsZeng/pinentry-fuzzel";
      flake = false;
    };

    sublime-text-gleam = {
      url = "github:digitalcora/sublime-text-gleam";
      flake = false;
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-unstable = {
      url = "github:niri-wm/niri/pull/3508/head"; # open-consume-into-window
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake/pull/1717/head"; # extraConfig
      inputs.niri-unstable.follows = "niri-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-autoselect-portal.url = "git+https://codeberg.org/debugloop/niri-autoselect-portal.git";
    niri-notify-focus = {
      url = "github:Oaklight/niri-notify-focus/pull/1/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "pkgs-unstable";
        home-manager.follows = "home-manager";
      };
    };

    # work
    globalprotect-openconnect = {
      url = "github:yuezk/GlobalProtect-openconnect";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sentinelone = {
      url = "github:devusb/sentinelone-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      overlays = [
        inputs.gen-luarc.overlays.default
        inputs.enhansi.overlays.default
        inputs.niri-flake.overlays.niri
        (final: prev: {
          unstable = import inputs.pkgs-unstable {
            system = prev.system;
          };
        })
      ];
      baseColors = {
        background = "162229";
        black = "1b2b34";
        dark_red = "c75c5c";
        dark_green = "8fa35a";
        dark_yellow = "b49545";
        dark_blue = "659093";
        dark_magenta = "a06c85";
        dark_cyan = "6e9a6e";
        gray = "bfb47e";
        bright_black = "46586a";
        red = "ea6962";
        yellow = "d8a657";
        green = "a9b665";
        blue = "7daea3";
        magenta = "d3869b";
        cyan = "89b482";
        white = "efe2bc";
      };
      indexed = import ./utils/color256.nix baseColors;
      colors = {
        named = baseColors;
        inherit indexed;
      };
      specialArgs = {
        inherit inputs;
        inherit colors;
      };
    in

    flake-parts.lib.mkFlake { inherit inputs; } {

      flake.nixosConfigurations = {
        thia = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./nixos/thia.nix
          ];
        };

        itamo = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./nixos/itamo.nix
          ];
        };

        inix = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.overlays = overlays;
            }
            ./nixos/inix.nix
          ];
        };

        nuc = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./nixos/nuc.nix
          ];
        };

        flake.nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./nixos/iso.nix
          ];
        };
      };

      flake.homeConfigurations = {
        nixos = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = overlays;
          };
          extraSpecialArgs = {
            inherit inputs colors;
          };
          modules = [ ./home-manager/nixos.nix ];
        };

        work = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = overlays;
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit inputs colors;
          };
          modules = [ ./home-manager/work.nix ];
        };

        darwin = home-manager.lib.homeManagerConfiguration {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            overlays = overlays;
          };
          extraSpecialArgs = {
            inherit inputs colors;
            home = {
              user = "vargasd";
              homeDirectory = "/Users/vargasd";
            };
            skhdVars = {
              issues = "open https://github.com/vargasd";
              videoconf = "open -a facetime";
            };
          };
          modules = [ ./home-manager/darwin ];
        };
      };

      perSystem =
        { system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            inherit overlays;
          };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              emmylua-ls
              stylua
              nixd
              nixfmt
            ];

            shellHook =
              let
                luarc = pkgs.mk-luarc-json { plugins = import ./utils/vim-pkgs.nix pkgs; };
              in
              /* bash */ ''
                ln -fs ${luarc} .luarc.json
              '';
          };
        };

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    };
}
