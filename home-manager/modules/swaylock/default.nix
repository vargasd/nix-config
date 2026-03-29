{ colors, ... }:
{
  programs.swaylock = {
    enable = true;
    settings = with colors.named; {
      font = "monospace";
      color = background;
      inside-color = background;
      font-size = 16;
      indicator-radius = 100;
      indicator-thickness = 15;
      disable-caps-lock-text = true;
      key-hl-color = magenta;
      bs-hl-color = red;
      ring-color = white;
      text-color = white;
      text-ver-color = white;
      text-wrong-color = white;
      text-clear-color = white;
      inside-clear-color = dark_yellow;
      ring-clear-color = yellow;
      ring-ver-color = blue;
      inside-ver-color = dark_blue;
      ring-wrong-color = red;
      inside-wrong-color = dark_red;
    };
  };
}
