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
      flake = false;
    };

    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

    nvim-next = {
      url = "github:ghostbuster91/nvim-next";
      flake = false;
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
  };

  outputs =
    {
      home-manager,
      nix-darwin,
      flake-utils,
      nixpkgs,
      gen-luarc,
      ...
    }@inputs:
    let
      vimPkgs = (
        pkgs:
        with pkgs.vimPlugins;
        (
          [
            # lazy
            mini-surround
            vim-sleuth
            flash-nvim
            (pkgs.vimUtils.buildVimPlugin {
              pname = "nvim-next";
              src = inputs.nvim-next;
              version = inputs.nvim-next.rev;
            })

            vim-fugitive
            gitsigns-nvim

            blink-cmp

            cmp-dap
            blink-compat
            nvim-dap
            nvim-dap-virtual-text

            vim-dadbod
            vim-dadbod-completion
            vim-dadbod-ui

            persisted-nvim
            which-key-nvim
            yazi-nvim
            nvim-treesitter-textobjects
            undotree
            lualine-nvim
            noice-nvim
            nui-nvim
            render-markdown-nvim
            rainbow_csv
          ]
          |> map (plugin: {
            plugin = plugin;
            optional = true;
          })
        )

        ++ [
          # eager
          lze
          nvim-lspconfig
          snacks-nvim
          nvim-treesitter.withAllGrammars # sure why not

          (pkgs.vimUtils.buildVimPlugin {
            pname = "enhansi";
            src = inputs.enhansi;
            version = inputs.enhansi.rev;
          })
        ]
      );
    in
    {
      nixosConfigurations.nuc = nixpkgs.lib.nixosSystem (
        let
          specialArgs = {
            inherit inputs;
            vimPkgs = vimPkgs;
            home = {
              homeDirectory = "/home/vargasd";
              user = "vargasd";
            };
            additionalConfig = { };
          };
        in
        {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration.nix
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
        inputs = {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              gen-luarc.overlays.default
            ];
          };
          vimPkgs = vimPkgs;
          helpers = {
            extendJsonEnvVar =
              pkgs: varName: json:
              pkgs.lib.attrsets.recursiveUpdate (
                builtins.getEnv varName
                |> (val: if val == null || val == "" then "{}" else val) # handle invalid JSON?
                |> builtins.fromJSON
              ) json
              |> builtins.toJSON;
          };
        };
      in
      {
        devShells = {
          biome = import ./devShells/biome.nix inputs;
          c = import ./devShells/c.nix inputs;
          gcp = import ./devShells/gcp.nix inputs;
          gleam = import ./devShells/gleam.nix inputs;
          kotlin = import ./devShells/kotlin.nix inputs;
          lua = import ./devShells/lua.nix inputs;
          nix = import ./devShells/nix.nix inputs;
          node24 = import ./devShells/node24.nix inputs;
          node22 = import ./devShells/node22.nix inputs;
          node20 = import ./devShells/node20.nix inputs;
          php = import ./devShells/php.nix inputs;
          pnpm = import ./devShells/pnpm.nix inputs;
          ruby = import ./devShells/ruby.nix inputs;
          terraform = import ./devShells/terraform.nix inputs;
          tsserver = import ./devShells/tsserver.nix inputs;
          vue = import ./devShells/vue.nix inputs;
        };
      }
    ));
}
