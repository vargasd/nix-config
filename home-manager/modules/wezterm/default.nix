{ colors, ... }:
{
  programs.wezterm = {
    enable = true;
    colorSchemes = {
      bluvbox =
        let
          hexColors = colors.named |> builtins.mapAttrs (n: val: "#${val}");
          # Full 256-color indexed palette (indices 16-255); 0-15 are ansi/brights
          indexedPalette = builtins.listToAttrs (
            builtins.genList (i: {
              name = builtins.toString (i + 16);
              value = "#${builtins.elemAt colors.indexed (i + 16)}";
            }) 240
          );
        in
        with hexColors;
        {
          background = background;
          foreground = white;
          cursor_bg = white;
          cursor_border = white;
          cursor_fg = background;
          selection_bg = "#343d46";
          selection_fg = white;
          indexed = indexedPalette;
          ansi = [
            black
            dark_red
            dark_green
            dark_yellow
            dark_blue
            dark_magenta
            dark_cyan
            gray
          ];
          brights = [
            bright_black
            red
            green
            yellow
            blue
            magenta
            cyan
            white
          ];
          # these should really be in the main config but whaddya gonna do
          tab_bar = {
            background = background;
            active_tab = {
              bg_color = yellow;
              fg_color = background;
            };
            inactive_tab = {
              bg_color = bright_black;
              fg_color = background;
            };
          };
        };
    };
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  xdg.configFile."wezterm/plugins" = {
    enable = true;
    source = ./plugins;
  };
}
