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

setopt PROMPT_SUBST
export PROMPT='
%B%(?.%F{green}.%F{red})%~ %F{cyan}$(
	git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null
)
%F{yellow}→ %f%b'

ZSH_TITLE=""
function xtitle () {
	if [[ $# > 0 ]]; then
		ZSH_TITLE=$@
	fi

	builtin print -n -- "\e]0;${ZSH_TITLE:-${(D)PWD}}\a"
}
xtitle

function precmd () { xtitle }
