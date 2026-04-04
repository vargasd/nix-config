# shift-tab backwards through menu
bindkey -M emacs '^[[Z' reverse-menu-complete
# completion menu highlighting
zstyle ':completion:*' menu select
# case-insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# better word navigation
autoload -U select-word-style
select-word-style bash

# bind [delete] for forward deletion
bindkey -M emacs "^[[3~" delete-char
bindkey -M emacs "^[3;5~" delete-char

setopt INC_APPEND_HISTORY

setopt PROMPT_SUBST
export PROMPT='
%B%(?.%F{green}.%F{red})%~ %F{cyan}$(
	git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null
)
%F{yellow}→ %f%b'

function xtitle () {
		builtin print -n -- "\e]0;$PWD\a"
}

function precmd () { 
	if [[ "$TERM" == "wezterm" ]]; then
		xtitle 
	fi
}

xtitle
