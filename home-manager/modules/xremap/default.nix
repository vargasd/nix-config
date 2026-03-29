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
      ];
    };
  };
}
