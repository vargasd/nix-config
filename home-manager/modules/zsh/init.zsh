# shift-tab backwards through menu
bindkey -M emacs '^[[Z' reverse-menu-complete
# completion menu highlighting
zstyle ':completion:*' menu select
# case-insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# better word navigation
autoload -U select-word-style
select-word-style bash

setopt INC_APPEND_HISTORY
setopt PROMPT_SUBST

function zmx-session () {
  local dir
  dir=$(zoxide query --interactive </dev/tty)
  if [[ -n "$dir" ]]; then
    BUFFER="$(zmx_launch_cmd "$dir")"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N .zmx-session zmx-session
bindkey -M emacs "\es" .zmx-session

function zmx-subsession () {
  if [[ -n "$ZMX_SESSION" ]]; then
    local n="${1:-${WIDGET##.zmx-subsession_}}"
    zmx_subsession "$n"
  fi
}
for i in {1..9}; do
  zle -N ".zmx-subsession_$i" zmx-subsession
  bindkey -M emacs "\e$i" ".zmx-subsession_$i"
done

function zmx-scrollback () {
  if [[ -n "$ZMX_SESSION" ]]; then
    zle -I
    zmx_scrollback
    zle reset-prompt
  fi
}
zle -N .zmx-scrollback zmx-scrollback
bindkey -M emacs "\ez" .zmx-scrollback
