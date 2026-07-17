$env.config.keybindings = ($env.config.keybindings | append [
    {
        name: zmx_session
        modifier: alt
        keycode: char_s
        mode: [emacs]
        event: {send: executehostcommand, cmd: "_zmx_session_keybind"}
    }
    {
        name: zmx_scrollback
        modifier: alt
        keycode: char_z
        mode: [emacs]
        event: {send: executehostcommand, cmd: "_zmx_scrollback_keybind"}
    }
    {
        name: zmx_sub_1
        modifier: alt
        keycode: char_1
        mode: [emacs]
        event: {send: executehostcommand, cmd: "s 1"}
    }
    {
        name: zmx_sub_2
        modifier: alt
        keycode: char_2
        mode: [emacs]
        event: {send: executehostcommand, cmd: "s 2"}
    }
    {
        name: zmx_sub_3
        modifier: alt
        keycode: char_3
        mode: [emacs]
        event: {send: executehostcommand, cmd: "s 3"}
    }
    {
        name: zmx_sub_4
        modifier: alt
        keycode: char_4
        mode: [emacs]
        event: {send: executehostcommand, cmd: "s 4"}
    }
    {
        name: zmx_sub_5
        modifier: alt
        keycode: char_5
        mode: [emacs]
        event: {send: executehostcommand, cmd: "s 5"}
    }
    {
        name: zmx_sub_6
        modifier: alt
        keycode: char_6
        mode: [emacs]
        event: {send: executehostcommand, cmd: "s 6"}
    }
    {
        name: zmx_sub_7
        modifier: alt
        keycode: char_7
        mode: [emacs]
        event: {send: executehostcommand, cmd: "s 7"}
    }
    {
        name: zmx_sub_8
        modifier: alt
        keycode: char_8
        mode: [emacs]
        event: {send: executehostcommand, cmd: "s 8"}
    }
    {
        name: zmx_sub_9
        modifier: alt
        keycode: char_9
        mode: [emacs]
        event: {send: executehostcommand, cmd: "s 9"}
    }
])
# https://www.nushell.sh/cookbook/external_completers.html#fish-completer
let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'" | from tsv --flexible --noheaders --no-infer | rename value description | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}
$env.config.completions = {
    external: {
        enable: true
        completer: $fish_completer
    }
}
def create_left_prompt [] {
    let code = $env.LAST_EXIT_CODE
    let cwd = ($env.PWD | str replace --regex $'^($env.HOME)' '~')
    let cwd_colored = if $code == 0 {
        $"(ansi green)($cwd)(ansi reset)"
    } else {
        $"(ansi red)($cwd)(ansi reset)"
    }
    let session_part = if ($env | get -o ZMX_SESSION | is-not-empty) {
        $" (ansi magenta)($env.ZMX_SESSION)(ansi reset)"
    } else { "" }
    let git_ref = (try {
        git symbolic-ref --short HEAD err> /dev/null | str trim
    } catch {
        try {
            git rev-parse --short HEAD err> /dev/null | str trim
        } catch { "" }
    })
    let git_part = if ($git_ref | is-not-empty) {
        $" (ansi cyan)($git_ref)(ansi reset)"
    } else { "" }
    $"\n($cwd_colored)($session_part)($git_part)\n(ansi yellow)→ (ansi reset)"
}
$env.PROMPT_COMMAND = { create_left_prompt }
def s [n: int = 1] {
    let session = if ($env | get -o ZMX_SESSION | is-not-empty) {
        let base = ($env.ZMX_SESSION | split row "#" | first)
        $"($base)#($n)"
    } else {
        let base = ($env.PWD | path basename)
        $"($base)#($n)"
    }
    zmx attach $session nu
}
def _zmx_session_keybind [] {
    if ($env | get -o NVIM | is-empty) {
        let dir = (zoxide query --interactive)
        if ($dir | is-not-empty) {
            let dir = ($dir | str trim)
            let session = $"(($dir | path basename))#1"
            nu -c $"cd ($dir | to nuon); zmx attach ($session | to nuon) nu"
        }
    }
}
def _zmx_scrollback_keybind [] {
    if ($env | get -o NVIM | is-empty) {
        if ($env | get -o ZMX_SESSION | is-not-empty) {
            zmx history $env.ZMX_SESSION --vt | nvim -c ':call nvim_open_term(0, #{})'
        }
    }
}
