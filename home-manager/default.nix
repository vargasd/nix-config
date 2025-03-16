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

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.git = {
    enable = true;

    aliases = {
      co = "checkout";
      bco = "!f() { git checkout -b \"$(whoami)/$1\"; }; f";
      bclean = "!f() { git branch --merged origin/main | xargs git branch -D; }; f";
      fu = "commit --fixup";
      fua = "commit -a --fixup";
      graph = "log --graph --pretty=mine";
      g = "log --graph --pretty=mine";
      ga = "log --graph --all --pretty=mine";
      mt = "mergetool";
      pf = "push --force";
      ri = "!f() { git rebase -i ${"1:-origin/main"}; }; f";
      ra = "rebase --abort";
      rc = "rebase --continue";
      reste = "reset";
    };

    ignores = [
      ".DS_Store"
      "[._]*.s[a-w][a-z]"
      "[._]s[a-w][a-z]"
      "Session.vim"
      ".vim"
      ".samignore"
      ".gitoverlay"
    ];

    delta = {
      enable = true;
      options = {
        navigate = true;
        tabs = 2;
        syntax-theme = "enhansi";
      };
    };

    extraConfig = {
      log.date = "format-local:%F %R";
      column.ui = "auto";
      commit.gpgSign = true;
      # core.pager = "bat"; # conflict with delta.enabled
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        writeCommitGraph = true;
      };
      grep.lineNumber = true;
      help.autocorrect = "prompt";
      init.defaultBranch = "main";
      pager.difftool = true;
      pretty.mine = "%C(auto)%h%C(brightgreen bold)% (trailers:key=closes,valueonly,separator=%x2C)%C(brightblue bold)% (trailers:key=ref,valueonly,separator=%x2C) %C(auto)%s %C(cyan)%aL/%C(blue)%cL %C(magenta)%cd%C(auto)%d";
      pull.rebase = true;
      push = {
        default = "current";
        autoSetupRemote = true;
        followTags = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      receive.denyCurrentBranch = "warn";
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      tag = {
        gpgSign = true;
        sort = "version:refname";
      };
      user = {
        email = "sam@vargasd.com";
        name = "Samuel Varga";
        signingKey = "9360638973266EE4";
      };
      merge = {
        tool = "nvimdiff";
        conflictStyle = "zdiff3";
      };
      mergetool = {
        keepBackup = false;
        nvimdiff.layout = "LOCAL,REMOTE / MERGED";
        vimdiff.layout = "LOCAL,REMOTE / MERGED";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
