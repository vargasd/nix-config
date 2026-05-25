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
            "librewolf"
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
            "ctrl-u" = [
              "shift-home"
              "backspace"
            ];
          };
        }
        {
          name = "foot keybinds";
          application."only" = [ "/^foot/" ];
          exact_match = true;
          remap = {
            "super-t".launch = [
              "foot"
              "--app-id"
              "foot.main"
            ];
            "super-s".launch = [
              "bash"
              "-c"
              /* bash */ ''
                dir=$(printf "$HOME\n$(zoxide query --list)" | fuzzel -d)
                wlrctl window focus "app_id:foot.main" "title:$dir" || foot --app-id foot.main --working-directory "$dir" zmx attach "$(basename $dir)#1"
              ''
            ];
          };
        }
      ];
    };
  };
}
