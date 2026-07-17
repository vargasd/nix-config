{
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableVteIntegration = true;
    defaultKeymap = "emacs";

    history = {
      append = false;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = false;
    };

    initContent = /* zsh */ ''
      # shift-tab backwards through menu
      bindkey '^[[Z' reverse-menu-complete
      # completion menu highlighting
      zstyle ':completion:*' menu select
      # case-insensitive completion
      zstyle ':completion:*' matcher-list '''''' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

      # better word navigation
      autoload -U select-word-style
      select-word-style bash

      # bind [delete] for forward deletion
      bindkey "^[[3~" delete-char
      bindkey "^[3;5~" delete-char

      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^O" edit-command-line

      setopt PROMPT_SUBST

      export PROMPT='
      %B%(?.%F{green}.%F{red})%~%F{magenta} $ZMX_SESSION
      %F{yellow}→ %f%b'
    '';
  };
}
