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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "pkgs-unstable";
        home-manager.follows = "home-manager";
      };
    };

    textfox = {
      url = "github:vargasd/textfox";
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
    in

    flake-parts.lib.mkFlake { inherit inputs; } {

      flake.nixosConfigurations.thia = nixpkgs.lib.nixosSystem (
        let
          specialArgs = {
            inherit inputs;
            inherit colors;
            home = {
              homeDirectory = "/home/vargasd";
              user = "vargasd";
            };
          };
        in
        {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.overlays = overlays;
            }
            ./nixos/thia.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${specialArgs.home.user} = import ./home-manager/nixos.nix;
            }
          ];
        }
      );

      flake.nixosConfigurations.itamo = nixpkgs.lib.nixosSystem (
        let
          specialArgs = {
            inherit inputs;
            inherit colors;
            home = {
              homeDirectory = "/home/vargasd";
              user = "vargasd";
            };
          };
        in
        {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.overlays = overlays;
            }
            ./nixos/itamo.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${specialArgs.home.user} = import ./home-manager/nixos.nix;
            }
          ];
        }
      );

      flake.nixosConfigurations.inix = nixpkgs.lib.nixosSystem (
        let
          specialArgs = {
            inherit inputs;
            inherit colors;
            home = {
              homeDirectory = "/home/vargasd";
              user = "vargasd";
            };
          };
        in
        {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.overlays = overlays;
            }
            ./nixos/inix.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${specialArgs.home.user} = import ./home-manager/nixos.nix;
            }
          ];
        }
      );

      flake.nixosConfigurations.nuc = nixpkgs.lib.nixosSystem (
        let
          specialArgs = {
            inherit inputs;
            inherit colors;
            home = {
              homeDirectory = "/home/vargasd";
              user = "vargasd";
            };
          };
        in
        {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            ./nixos/nuc.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${specialArgs.home.user} = import ./home-manager/nixos.nix;
            }
          ];
        }
      );

      flake.homeConfigurations.work = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = overlays;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs colors;
          home = {
            homeDirectory = "/Users/I763291";
            user = "I763291";
            defaultbrowser = "firefox";
          };
          skhdVars = {
            issues = "open 'https://emarsys.jira.com/jira/software/c/projects/SC/boards/1088?quickFilter=3743'";
            videoconf = "open -a 'Microsoft Teams'";
          };
        };
        modules = [ ./home-manager/darwin/work.nix ];
      };

      flake.homeConfigurations.darwin = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = overlays;
        };
        extraSpecialArgs = {
          inherit inputs colors;
          home = {
            user = "vargasd";
            homeDirectory = "/Users/vargasd";
            defaultbrowser = "firefox";
          };
          skhdVars = {
            issues = "open https://github.com/vargasd";
            videoconf = "open -a facetime";
          };
        };
        modules = [ ./home-manager/darwin ];
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
