{ colors, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=15";
      };
      colors =
        with colors.named;
        {
          background = background;
          text = white;
          message = white;
          prompt = magenta;
          placeholder = bright_black;
          input = white;
          match = magenta;
          selection = bright_black;
          selection-text = white;
          selection-match = magenta;
          border = bright_black;
        }
        |> builtins.mapAttrs (n: val: "${val}ff");
      border.radius = 0;
    };
  };
}
