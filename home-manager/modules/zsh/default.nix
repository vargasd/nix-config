{
  pkgs,
  ...
}:
{
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

    initContent = builtins.readFile ./init.zsh + ''
      source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
      eval "$(zmx completions zsh)"
    '';
  };
}
