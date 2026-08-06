{ pkgs, ... }: {

  home.packages = [ pkgs.kubectl ];

  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        readonly = true;
        skin = "term";
      };
    };
    skins = {
      term = ./k9s-skin.yaml;
    };
  };
}
