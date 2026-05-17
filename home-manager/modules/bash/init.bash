# shift-tab backwards through menu
bind '"\e[Z": menu-complete-backward'
# completion menu
bind 'Tab:menu-complete'
bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
# case-insensitive completion
bind 'set completion-ignore-case on'

function _zmx_session () {
  local dir
  dir=$(zoxide query --interactive </dev/tty)
  if [[ -n "$dir" ]]; then
    eval "$(zmx_launch_cmd "$dir")"
  fi
}
bind -x '"\M-s": _zmx_session'

for i in {1..9}; do
  bind -x "\"\\M-$i\": zmx_subsession $i"
done

bind -x '"\M-z": zmx_scrollback'
