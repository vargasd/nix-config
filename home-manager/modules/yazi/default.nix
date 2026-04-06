{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    initLua = # lua
      ''
        th.git = th.git or {}
        th.git.modified = ui.Style():fg("blue")
        th.git.deleted = ui.Style():fg("red")
        th.git.added = ui.Style():fg("green")
        th.git.ignored = ui.Style():fg("darkgray")

        th.git.modified_sign = "M"
        th.git.added_sign = "A"
        th.git.untracked_sign = "U"
        th.git.ignored_sign = "I"
        th.git.deleted_sign = "D"

        require("git"):setup()
      '';

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = "f";
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
      ];
    };

    plugins = {
      git = pkgs.yaziPlugins.git;
      chmod = pkgs.yaziPlugins.chmod;
      piper = pkgs.yaziPlugins.piper;
      "jump-to-char" = pkgs.yaziPlugins.jump-to-char;
    };

    theme = {
      icon = {
        dirs = [ ];
        conds = [
          {
            "if" = "orphan";
            text = "";
            fg = "white";
          }
          {
            "if" = "link";
            text = "";
            fg = "gray";
          }
          {
            "if" = "block";
            text = "";
            fg = "yellow";
          }
          {
            "if" = "char";
            text = "";
            fg = "yellow";
          }
          {
            "if" = "fifo";
            text = "";
            fg = "yellow";
          }
          {
            "if" = "sock";
            text = "";
            fg = "yellow";
          }
          {
            "if" = "sticky & dir";
            text = "󰉐";
            fg = "yellow";
          }
          {
            "if" = "sticky & !dir";
            text = "";
            fg = "yellow";
          }
          {
            "if" = "dummy";
            text = "";
            fg = "red";
          }
          {
            "if" = "dir";
            text = "";
            fg = "blue";
          }
          {
            "if" = "exec";
            text = "";
            fg = "green";
          }
          {
            "if" = "!dir";
            text = "";
            fg = "white";
          }
        ];
      };
    };

    settings = {
      mgr = {
        show_hidden = true;
        sort_by = "natural";
        sort_reverse = false;
        sort_dir_first = true;
      };

      plugin.prepend_previewers =
        let
          bat = "piper -- bat -p --color=always \"$1\"";
        in
        [
          {
            name = "*.tsp";
            run = bat;
          }
          {
            name = "*.gleam";
            run = bat;
          }
        ];

      plugin.prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
    };
  };

  xdg.desktopEntries.yazi = {
    name = "yazi";
    noDisplay = true;
  };
}
