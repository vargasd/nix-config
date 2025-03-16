{ pkgs, ... }:
{
  home.stateVersion = "25.05";
  home.username = "sam";
  home.homeDirectory = "/Users/sam";

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

  programs.zsh = {
    enable = true;
    enableVteIntegration = true;

    history = {
      append = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      save = 50000;
      size = 50000;
      share = true;
    };

    initContent = builtins.readFile ./init.zsh;

    initExtra = "source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh";

    shellAliases = {
      jqi = ''
        f() { 
          echo "" | fzf -q "." \
          --bind "shift-up:preview-half-page-up,shift-down:preview-half-page-down,load:unbind(enter)" \
          --preview-window "bottom:99%" \
          --print-query \
          --preview "cat $1 | jq ''\${@:2} {q} | bat --color=always --plain -l json" \
        }; f'';
      man = "batman";
    };

    sessionVariables = {
      LESS = "-i -R --no-init --tabs 2";
      LESSHISTFILE = "-";
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

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
