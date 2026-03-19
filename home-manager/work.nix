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
    claude-code
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
        config-connector
      ]
    ))
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
