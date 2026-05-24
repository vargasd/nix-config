# shift-tab backwards through menu
bindkey '^[[Z' reverse-menu-complete
# completion menu highlighting
zstyle ':completion:*' menu select
# case-insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# better word navigation
autoload -U select-word-style
select-word-style bash

# bind [delete] for forward deletion
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

setopt INC_APPEND_HISTORY

setopt PROMPT_SUBST
export PROMPT='
%B%(?.%F{green}.%F{red})%~%F{magenta}${ZMX_SESSION:+ $ZMX_SESSION} %F{cyan}$(
  git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null
)
%F{yellow}→ %f%b'

function s () {
  local n="${1:-1}"
  if [[ -n "$ZMX_SESSION" ]]; then
    zmx attach "$(echo $ZMX_SESSION | cut -d# -f1)#$n"
  else
    zmx attach "${PWD:t}#$n"
  fi
}

function zmx-session () {
  local dir
  dir=$(zoxide query --interactive </dev/tty)
  if [[ -n "$dir" ]]; then
    local session="${dir:t}#1"
    BUFFER="zsh -c 'cd ${(q)dir} && zmx attach ${(q)session}'"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N .zmx-session zmx-session

function zmx-subsession () {
  if [[ -n "$ZMX_SESSION" ]]; then
    local n="${1:-${WIDGET##.zmx-subsession_}}"
    zmx attach "$(echo $ZMX_SESSION | cut -d# -f1)#$n"
  fi
}

function zmx-scrollback () {
  if [[ -n "$ZMX_SESSION" ]]; then
    zle -I
    zmx history "$ZMX_SESSION" --vt | nvim -c ':call nvim_open_term(0, #{})'
    zle reset-prompt
  fi
}
zle -N .zmx-scrollback zmx-scrollback

if [[ -z "$NVIM" ]]; then
  bindkey "^[s" .zmx-session
  bindkey "^[z" .zmx-scrollback
  for i in {1..9}; do
    zle -N ".zmx-subsession_$i" zmx-subsession
    bindkey "^[$i" ".zmx-subsession_$i"
  done
fi

function xtitle () {
  builtin print -n -- "\e]0;$PWD\a"
}

function precmd () {
  if [[ "$TERM" == "wezterm" ]]; then
    xtitle
  fi
}

xtitle
