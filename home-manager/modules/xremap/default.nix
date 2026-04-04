{ inputs, ... }:
{
  imports = [
    inputs.xremap.homeManagerModules.default
  ];

  services.xremap = {
    enable = true;
    withNiri = true;
    config = {
      keymap = [
        {
          name = "emacs keys";
          # put all GUI apps here; apparently the only way to get fuzzel working
          application."only" = [
            "firefox"
          ];
          exact_match = true;
          remap = {
            "ctrl-a" = "home";
            "ctrl-e" = "end";
            "alt-b" = "ctrl-left";
            "alt-f" = "ctrl-right";
            "shift-ctrl-a" = "shift-home";
            "shift-ctrl-e" = "shift-end";
            "shift-alt-b" = "shift-ctrl-left";
            "shift-alt-f" = "shift-ctrl-right";

            "ctrl-w" = "ctrl-backspace";
            # TODO fix ctrl-u for fuzzel application.not doesn't work
            "ctrl-u" = [
              "shift-home"
              "backspace"
            ];
          };
        }
        {
          name = "foot keybinds";
          application."only" = [ "foot.main" ];
          exact_match = true;
          remap = {
            "super-s".launch = [
              "bash"
              "-c"
              /* bash */ ''
                zoxide query --list |\
                fuzzel -d |\
                xargs -I {} sh -c \
                'wlrctl window focus "app_id:foot.main" "title:{}" || (foot --app-id foot.main --working-directory "{}" sh -c "niri msg action consume-or-expel-window-left && $SHELL")'
              ''
            ];
            "super-t".launch = [
              "bash"
              "-c"
              /* bash */ ''
                wlrctl toplevel list state:focused |\
                cut -d' ' -f2- |\
                xargs -I {} sh -c \
                'foot --app-id foot.main --working-directory "{}" sh -c "niri msg action consume-or-expel-window-left && $SHELL"'
              ''
            ];
          };
        }
      ];
    };
  };
}
