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

    langthing = {
      url = "github:vargasd/langthing";
      flake = false;
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

    paneru = {
      # TODO: switch back to karinushka/paneru after PR(s) merged
      url = "github:vargasd/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
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
    let
      overlays = [
        inputs.gen-luarc.overlays.default
        inputs.enhansi.overlays.default
      ];
      vimPkgs = (
        pkgs:
        with pkgs.vimPlugins;
        (
          # lazy
          [
            mini-surround
            vim-sleuth
            flash-nvim
            nvim-next
            vim-fugitive
            gitsigns-nvim
            blink-cmp
            nvim-dap
            nvim-dap-virtual-text
            vim-dadbod
            vim-dadbod-completion
            vim-dadbod-ui
            which-key-nvim
            yazi-nvim
            nvim-treesitter-textobjects
            undotree
            lualine-nvim
            noice-nvim
            nui-nvim
            render-markdown-nvim
            rainbow_csv
            nvim-lspconfig
            snacks-nvim
            nvim-treesitter.withAllGrammars # sure why not
          ]
          |> map (plugin: {
            plugin = plugin;
            optional = true;
          })
        )
        # eager
        ++ [
          lze
          enhansi-nvim
        ]
      );
      colors = {
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

    in
    {
      nixosConfigurations.nuc = nixpkgs.lib.nixosSystem (
        let
          specialArgs = {
            inherit inputs;
            inherit colors;
            vimPkgs = vimPkgs;
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
              home-manager.users.${specialArgs.home.user} = import ./home-manager/default.nix;
            }
          ];
        }
      );

      darwinConfigurations.work = nix-darwin.lib.darwinSystem (
        let
          specialArgs = {
            inherit inputs;
            inherit colors;
            vimPkgs = vimPkgs;
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
        in
        {
          inherit specialArgs;
          modules = [
            ./nix-darwin
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config.allowUnfree = true;
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${specialArgs.home.user} = import ./home-manager/work.nix;
              users.users.${specialArgs.home.user}.home = specialArgs.home.homeDirectory;
            }
          ];
        }
      );

      darwinConfigurations.home = nix-darwin.lib.darwinSystem (
        let
          specialArgs = {
            inherit inputs;
            inherit colors;
            vimPkgs = vimPkgs;
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
        in
        {
          inherit specialArgs;
          modules = [
            ./nix-darwin
            {
              nixpkgs.overlays = overlays;
            }
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
          inherit overlays;
        };

        mkDevShell =
          {
            devEnvs,
            lspConfig ? { },
            packages ? [ ],
          }:
          pkgs.mkShell {
            packages = (devEnvs |> (map (cfg: cfg.packages or [ ])) |> builtins.concatLists) ++ packages;

            SAM_LSP_CONFIGS =
              devEnvs
              |> builtins.foldl' (
                acc: cfg: pkgs.lib.attrsets.recursiveUpdate acc (cfg.lspConfig or { })
              ) lspConfig
              |> builtins.toJSON;

            shellHook =
              devEnvs
              |> map (cfg: cfg.shellHook or "")
              |> builtins.filter (hook: hook != null && hook != "")
              |> builtins.concatStringsSep "\n";
          };

        devEnvs = {
          biome = import ./devShells/biome.nix { inherit pkgs; };
          c = import ./devShells/c.nix { inherit pkgs; };
          gleam = import ./devShells/gleam.nix { inherit pkgs; };
          kotlin = import ./devShells/kotlin.nix { inherit pkgs; };
          lua = import ./devShells/lua.nix { inherit pkgs vimPkgs; };
          nix = import ./devShells/nix.nix { inherit pkgs; };
          php = import ./devShells/php.nix { inherit pkgs; };
          pnpm = import ./devShells/pnpm.nix { inherit pkgs; };
          ruby = import ./devShells/ruby.nix { inherit pkgs; };
          terraform = import ./devShells/terraform.nix { inherit pkgs; };
          tsserver = import ./devShells/tsserver.nix { inherit pkgs; };
          vue = import ./devShells/vue.nix { inherit pkgs; };
        };
      in
      {
        inherit devEnvs;
        inherit mkDevShell;
        devShells.default = mkDevShell {
          devEnvs = [
            devEnvs.nix
            devEnvs.lua
          ];
        };
      }
    ));
}
