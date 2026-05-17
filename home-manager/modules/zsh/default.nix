{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableVteIntegration = true;
    defaultKeymap = "emacs";
    dotDir = "${config.xdg.configHome}/zsh";

    history = {
      append = false; # using INC_APPEND_HISTORY which home-manager doesn't support
      ignoreAllDups = true;
      ignoreSpace = true;
      save = 50000;
      size = 50000;
      share = false;
    };

    completionInit = # zsh
      ''
        autoload -Uz compinit
        fpath=(''${(ou)fpath}) # Stable fpath order hence consistent cache hit.
        if [[ ! -s ''${ZDOTDIR:-$HOME}/.zcompdump || \
              /run/current-system/sw -nt ''${ZDOTDIR:-$HOME}/.zcompdump ]]; then
          compinit
          zcompile ''${ZDOTDIR:-$HOME}/.zcompdump 2>/dev/null
        else
          compinit -C
        fi
      '';

    initContent = builtins.readFile ./init.zsh + ''
      source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
      eval "$(${lib.getExe pkgs.zmx} completions zsh)"
    '';

    shellAliases = {
      nixpkgs-search = # sh
        ''
          nix search nixpkgs --no-write-lock-file --reference-lock-file ${../../../flake.lock} ^ --json 2> /dev/null | \
          jq -r 'to_entries | .[] | ((.key | sub("^legacyPackages.[^.]*."; "")) + ": " + .value.description)' | \
          fzf --multi --bind 'enter:become(cut -d : -f 1 {+f})'
        '';
    };

  };
}
