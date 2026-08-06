{ pkgs, ... }:
{
  home.packages = [ pkgs.elinks ];

  xdg.configFile."elinks/elinks.conf" = {
    enable = false;
    source = ./elinks.conf;
  };
}
