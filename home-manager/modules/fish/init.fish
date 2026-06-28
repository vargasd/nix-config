# Many system defined special functions
# @fish-lsp-disable 4004

function zmx_launch_cmd
    set dir $argv[1]
    echo "$SHELL -c 'cd "(string escape $dir)" && zmx attach "(string escape $(basename $dir))#1"'"
end

function s
    set n (test -n "$argv[1]"; and echo $argv[1]; or echo 1)
    if test -n "$ZMX_SESSION"
        zmx attach (string split -f1 "#" $ZMX_SESSION)"#$n"
    else
        zmx attach (basename $PWD)"#$n"
    end
end

function zmx_subsession
    set n $argv[1]
    if test -n "$ZMX_SESSION"
        zmx attach (string split -f1 "#" $ZMX_SESSION)"#$n"
    end
end

function zmx_scrollback
    if test -n "$ZMX_SESSION"
        zmx history $ZMX_SESSION --vt | nvim -c ':call nvim_open_term(0, #{})'
    end
end

function _zmx_session
    set dir (zoxide query --interactive </dev/tty)
    if test -n "$dir"
        commandline -- (zmx_launch_cmd $dir)
        commandline -f execute
    else
        commandline -f repaint
    end
end

function _zmx_scrollback
    if test -n "$ZMX_SESSION"
        zmx_scrollback
        commandline -f repaint
    end
end

function fish_user_key_bindings
    if test -z "$NVIM"
        bind \es _zmx_session
        bind \ez _zmx_scrollback
        for i in 1 2 3 4 5 6 7 8 9
            bind \e$i "zmx_subsession $i"
        end
    end
end

function fish_prompt
    set -l code $status
    echo ""

    set -l cwd (string replace -r "^$HOME" "~" $PWD)
    if test $code -eq 0
        echo -n (set_color --bold green)$cwd
    else
        echo -n (set_color --bold red)$cwd
    end

    if test -n "$ZMX_SESSION"
        echo -n (set_color magenta)" $ZMX_SESSION"
    end

    set -l ref (git symbolic-ref --short HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)
    if test -n "$ref"
        echo -n (set_color cyan)" $ref"
    end
    echo ""
    echo -n (set_color yellow)"→ "(set_color normal)
end

function fish_title
    if test -n "$ZMX_SESSION"
        echo "$ZMX_SESSION"
    end
end
