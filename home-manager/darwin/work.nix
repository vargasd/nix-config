{ pkgs, ... }:
{
  imports = [
    ./default.nix
    ../modules/kubernetes
  ];

  home.sessionVariables = {
    PUPPETEER_EXECUTABLE_PATH = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser";
  };

  home.packages = with pkgs; [
    mongosh
    claude-code
    (google-cloud-sdk.withExtraComponents (
      with google-cloud-sdk.components;
      [
        gke-gcloud-auth-plugin
        config-connector
      ]
    ))
  ];
}
