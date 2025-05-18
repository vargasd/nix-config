{
  pkgs,
  inputs,
  additionalConfig,
  ...
}:
additionalConfig
// {
  home.stateVersion = "25.05";

  home.sessionVariables = {
    LESS = "-i -R --no-init --tabs 2";
    LESSHISTFILE = "-";
    HUSKY = 0;
  };

  home.packages = with pkgs; [
    ast-grep
    bat
    # brave
    btop
    delta
    docker
    eza
    fd
    fzf
    fzf-git-sh
    gh
    git
    gnupg
    ijq
    imagemagick
    jless
    jq
    lazygit
    lazydocker
    less
    k9s
    kubectl
    neofetch
    neovim
    nodejs
    openapi-tui
    pass
    postgresql
    ripgrep
    sqlite
    tmux # TODO There was an error in fzf-git-sh if tmux isn't installed, which doesn't feel right
    yazi
    yubikey-manager
    zoxide

    # TODO Use nix-env for most of these? At least the ones that you don't use all the time
    # language servers
    bash-language-server
    vscode-langservers-extracted # css, eslint, html, json
    efm-langserver
    harper
    marksman
    postgres-lsp
    rust-analyzer
    typescript-language-server
    typos-lsp
    vtsls
    yaml-language-server

    # formatters
    prettierd
  ];

  programs.home-manager.enable = true;

  programs.bat = {
    enable = true;
    config = {
      theme = "enhansi";
      style = "plain";
    };
    syntaxes = {
      typespec = {
        src = pkgs.fetchFromGitHub {
          owner = "vargasd";
          repo = "langthing";
          rev = "581e54ee64b46ace0fbd23e221ade8088f491d4e";
          hash = "sha256-/RLHHnCS4fMHPsSTRV/kLm7IUD2To3Hlk9vfiQG0UOs=";
        };
        file = "typespec/syntax/typespec.sublime-syntax";
      };
    };
    themes = {
      enhansi = {
        src = pkgs.fetchFromGitHub {
          owner = "vargasd";
          repo = "enhansi";
          rev = "7f28b3d4d4364309d8f098d99ba0d75e51bd3f2f";
          hash = "sha256-kU642R/ugvSWpi99WR2OYfN3RT+Li0fe0HraCT9BP6M=";
        };
        file = "enhansi.tmTheme";
      };
    };
    extraPackages = [ pkgs.bat-extras.batman ];
  };

  programs.browserpass.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      truecolor = false;
      rounded_corners = false;
      shown_boxes = "proc cpu mem";
      show_disks = false;
      update_ms = 5000;
      proc_tree = true;
      proc_per_core = false;
      log_level = "ERROR";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [ "--color=16" ];
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.git = import ./git.nix;

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
        };
      };
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  programs.yazi = {
    enable = true;
    initLua = # lua
      ''
        th.git = th.git or {}
        th.git.modified = ui.Style():fg("blue")
        th.git.deleted = ui.Style():fg("red")
        th.git.added = ui.Style():fg("green")
        th.git.ignored = ui.Style():fg("darkgray")

        th.git.modified_sign = "M"
        th.git.added_sign = "A"
        th.git.untracked_sign = "U"
        th.git.ignored_sign = "I"
        th.git.deleted_sign = "D"

        require("git"):setup()
      '';

    keymap = {
      manager.prepend_keymap = [
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
      ];
    };

    plugins = {
      git = inputs.yazi-plugins + "/git.yazi";
      chmod = inputs.yazi-plugins + "/chmod.yazi";
      piper = inputs.yazi-plugins + "/piper.yazi";
    };

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_reverse = false;
        sort_dir_first = true;
      };

      plugin.prepend_previewers = [
        {
          name = "*.tsp";
          run = "piper -- bat -p --color=always \"$1\"";
        }
      ];

      plugin.prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
    };
  };

  programs.zoxide = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableVteIntegration = true;
    defaultKeymap = "emacs";

    history = {
      append = false; # using INC_APPEND_HISTORY which home-manager doesn't support
      ignoreAllDups = true;
      ignoreSpace = true;
      save = 50000;
      size = 50000;
      share = false;
    };

    initContent =
      builtins.readFile ./init.zsh
      + ''
        source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
      '';

    shellAliases = {
      man = "batman";
      nvim = # sh
        "env TERM=\${SAMTERM:-$TERM} nvim";
      nixpkgs-search = # sh
        ''
          nix search nixpkgs --no-write-lock-file --reference-lock-file ${../flake.lock} ^ --json 2> /dev/null | \
          jq -r 'to_entries | .[] | ((.key | sub("^legacyPackages.[^.]*."; "")) + ": " + .value.description)' | \
          fzf --multi --bind 'enter:become(cut -d : -f 1 {+f})'
        '';
    };

  };

  services.ollama = {
    enable = true;
  };

  xdg = {
    enable = true;
    configFile.nvim = {
      enable = true;
      source = ./nvim;
    };
    configFile."typos-lsp/typos.toml" = {
      enable = true;
      text = # toml
        ''
          [default]
          extend-ignore-words-re = [
            "\\b[Nn]oice\\b"
          ]
        '';
    };
  };

  home.file = {
    "Library/Application Support/ueli/ueli9.settings.json".text = builtins.toJSON {
      "extensions.enabledExtensionIds" = [
        "SystemSettings"
        "ApplicationSearch"
        "UeliCommand"
      ];
      "general.hotkey" = "Cmd+Space";
    };
  };
}
