{ pkgs, ... }:
{
  xdg.configFile."keyd/app.conf" = {
    enable = true;
    text =
      let
        guiSettings = {
          "control.a" = "home";
          "control.e" = "end";
          "alt.b" = "C-left";
          "alt.f" = "C-right";
          "control.w" = "C-backspace";
          "control.u" = "macro(S-home backspace)";
        };
      in
      pkgs.lib.generators.toINI { } {
        firefox = guiSettings;
        zen-beta = guiSettings;
        "foot-main" = {
          "meta.t" = "C-f1";
          "meta.s" = "C-f2";
        };
        "ghostty-main" = {
          "meta.s" = "C-f4";
        };
      };
  };
}
