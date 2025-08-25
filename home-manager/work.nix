{ pkgs, ... }:
{
  imports = [
    ./darwin.nix
  ];

  home.sessionVariables = {
    PUPPETEER_EXECUTABLE_PATH = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser";
  };

  home.packages = with pkgs; [
    mongosh
    kubectl
  ];

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
