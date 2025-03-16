{ pkgs, ... }:
{
  home.stateVersion = "25.05";
  home.username = "sam";
  home.homeDirectory = "/Users/sam";

  programs.home-manager.enable = true;

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
    };

    sessionVariables = {
      # TODO use batman?
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
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
