user:
{ pkgs, inputs, ... }:
{
  home.stateVersion = "25.05";

  home.username = user;
  home.homeDirectory = "/Users/${user}";

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

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
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
        skipHookPrefix = "!";
      };
    };
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
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

    plugins =
      let
        plugins = pkgs.fetchFromGitHub {
          owner = "yazi-rs";
          repo = "plugins";
          rev = "cb6165b25515b653a70f72a67889579d190facfe";
          hash = "sha256-XDz67eHmVM5NrnQ/uPXN/jRgmrShs80anWnHpVmbPO8=";
        };
      in
      {
        git = plugins + "/git.yazi";
        chmod = plugins + "/chmod.yazi";
        bat = pkgs.fetchFromGitHub {
          owner = "vargasd";
          repo = "bat.yazi";
          rev = "e5f28d52e51450fe0d66e0d4661e6ba7b6d5edd6";
          hash = "sha256-tCOWMQC0Sea3DI0jEu28Qzzyt1l3bSuOlPWIRiHAQ50=";
        };
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
          run = "bat";
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
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableVteIntegration = true;

    history = {
      append = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      save = 50000;
      size = 50000;
      share = false;
    };

    initContent = builtins.readFile ./init.zsh;

    initExtra = "source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh";

    shellAliases = {
      jqi = # sh
        ''
          f() { 
            echo "" | fzf -q "." \
            --bind "shift-up:preview-half-page-up,shift-down:preview-half-page-down,load:unbind(enter)" \
            --preview-window "bottom:99%" \
            --print-query \
            --preview "cat $1 | jq ''\${@:2} {q} | bat --color=always --plain -l json" \
          }; f'';
      man = "batman";
      nvim = # sh
        "env TERM=wezterm nvim";
      jwtde = # sh
        ''
          f() {
            echo "$1" | jq -R 'split(".") | .[1] | @base64d | fromjson' 
          }
        '';
    };

    sessionVariables = {
      LESS = "-i -R --no-init --tabs 2";
      LESSHISTFILE = "-";
    };
  };

  targets.darwin = {
    keybindings = {
      "~b" = "moveWordBackward:";
      "~f" = "moveWordForward:";
      "^a" = "moveToBeginningOfLine:";
      "^e" = "moveToEndOfLine:";
      "~d" = "deleteWordForward:";
      "^w" = "deleteWordBackward:";
      "^u" = "deleteToBeginningOfLine:";
    };
  };

  xdg = {
    enable = true;
    configFile.nvim = {
      enable = true;
      source = ./nvim;
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
