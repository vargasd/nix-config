{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    generateCompletions = true;

    interactiveShellInit =
      # https://github.com/nix-community/home-manager/issues/6568
      (pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      '')
      + builtins.readFile ./init.fish
      + (
        {
          fish_greeting = "''";
          fish_color_normal = "brwhite"; # default color
          fish_color_keyword = "red"; # keywords like if - this falls back on the command color if unset
          fish_color_quote = "green"; # quoted text like "abc"
          fish_color_redirection = "white"; # IO redirections like >/dev/null
          fish_color_end = "white"; # process separators like ; and &
          fish_color_error = "red --underline=curly"; # syntax errors
          fish_color_param = "brwhite"; # ordinary command parameters
          fish_color_valid_path = "blue"; # parameters and redirection targets that are filenames (if the file exists)
          fish_color_option = "yellow"; # options starting with “-”, up to the first “--” parameter
          fish_color_comment = "brblack"; # comments like ‘# important’
          fish_color_operator = "magenta"; # parameter expansion operators like * and ~
          fish_color_escape = "magenta"; # character escapes like \n and \x70
          fish_color_autosuggestion = "brblack"; # autosuggestions (the proposed rest of a command)
        }
        |> pkgs.lib.mapAttrsToList (
          name: val: ''
            set -g ${name} ${val}
          ''
        )
        |> lib.strings.concatStrings
      )
      + /* fish */ ''
        source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.fish
        zmx completions fish | source
      '';
  };
}
