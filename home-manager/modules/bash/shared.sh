function zmx_launch_cmd () {
  local dir="$1"
  local session="${dir##*/}#1"
  printf "$SHELL -c 'cd %s && zmx attach %s'" "$(printf '%q' "$dir")" "$(printf '%q' "$session")"
}

function s () {
  local n="${1:-1}"
  if [ -n "$ZMX_SESSION" ]; then
    zmx attach "$(echo "$ZMX_SESSION" | cut -d# -f1)#$n"
  else
    zmx attach "$(basename "$PWD")#$n"
  fi
}

function zmx_subsession () {
  local n="$1"
  if [[ -n "$ZMX_SESSION" ]]; then
    zmx attach "$(echo "$ZMX_SESSION" | cut -d# -f1)#$n"
  fi
}

function zmx_scrollback () {
  if [[ -n "$ZMX_SESSION" ]]; then
    zmx history "$ZMX_SESSION" --vt | nvim -c ':call nvim_open_term(0, #{})'
  fi
}

function _prompt () {
  local exit=$?
  local cwd="${PWD/#$HOME/~}"
  local color_cwd; [ $exit -eq 0 ] && color_cwd='\e[1;32m' || color_cwd='\e[1;31m'
  local session; [ -n "$ZMX_SESSION" ] && session="\e[35m $ZMX_SESSION"
  local branch; branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  local color_branch; [ -n "$branch" ] && color_branch="\e[36m $branch"
  printf "\n${color_cwd}%s${session}${color_branch}\n\e[33m→ \e[0m" "$cwd"
}
PS1='$(_prompt)'

function xtitle () {
  printf '\e]0;%s\a' "$PWD"
}
xtitle
