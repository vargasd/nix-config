{ colors, ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "monospace:size=14";
      };
      cursor = {
        blink = false;
        blink-rate = 0;
      };
      colors =
        with colors.named;
        {
          background = background;
          foreground = white;
          regular0 = black;
          regular1 = dark_red;
          regular2 = dark_green;
          regular3 = dark_yellow;
          regular4 = dark_blue;
          regular5 = dark_magenta;
          regular6 = dark_cyan;
          regular7 = gray;
          bright0 = bright_black;
          bright1 = red;
          bright2 = green;
          bright3 = yellow;
          bright4 = blue;
          bright5 = magenta;
          bright6 = cyan;
          bright7 = white;
        }
        // builtins.listToAttrs (
          builtins.genList (i: {
            name = toString (i + 16);
            value = builtins.elemAt colors.indexed (i + 16);
          }) 240
        );
    };
  };
}
