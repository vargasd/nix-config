{ lib, ... }:
let
  baseColors = {
    background = "162229";
    black = "1b2b34";
    dark_red = "c75c5c";
    dark_green = "8fa35a";
    dark_yellow = "b49545";
    dark_blue = "659093";
    dark_magenta = "a06c85";
    dark_cyan = "6e9a6e";
    gray = "bfb47e";
    bright_black = "46586a";
    red = "ea6962";
    yellow = "d8a657";
    green = "a9b665";
    blue = "7daea3";
    magenta = "d3869b";
    cyan = "89b482";
    white = "efe2bc";
  };
in
{
  options.flake.colors = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.colors = {
    named = baseColors;
    indexed = import ../../utils/color256.nix baseColors;
  };
}
