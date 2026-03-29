{ inputs, pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "enhansi";
      style = "plain";
    };
    syntaxes = {
      typespec = {
        src = inputs.langthing;
        file = "typespec/syntax/typespec.sublime-syntax";
      };
      gleam = {
        src = inputs.sublime-text-gleam;
        file = "package/Gleam.sublime-syntax";
      };
    };
    themes.enhansi = {
      src = pkgs.enhansi-tmtheme;
      file = "enhansi.tmTheme";
    };
  };
}
