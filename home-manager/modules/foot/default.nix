{ colors, ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "JetBrainsMonoNL NF:weight:bold:size=16";
      };
      cursor = {
        blink = false;
        blink-rate = 0;
      };
      colors-dark =
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
      key-bindings = {
        clipboard-copy = "Super+c";
        clipboard-paste = "Super+v";
        search-start = "Super+f";
        font-increase = "Super+equal Super+plus";
        font-decrease = "Super+minus";
        font-reset = "Super+0";
        spawn-terminal = "Super+n";
        pipe-scrollback = "[sh -c \"f=$(mktemp) && cat - > $f; foot nvim -c ':set nowrap nonumber signcolumn=no readonly' $f; rm $f\"] Control+Shift+X";
        prompt-prev = "Control+Shift+P";
        prompt-next = "Control+Shift+N";
        #
      };
    };
  };
}
