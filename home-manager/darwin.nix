{ pkgs, ... }:
{
  imports = [
    ./default.nix
  ];

  home.sessionVariables = {
    PUPPETEER_EXECUTABLE_PATH = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser";
  };

  home.packages = with pkgs; [
    defaultbrowser
  ];

  services.gpg-agent.pinentry.package = pkgs.pinentry_mac;

  services.skhd = {
    enable = true;
    config =
      builtins.readFile ./darwin/skhdrc
      + ''
        meh - escape   : osascript "${./darwin/clear-notifications.scpt}"
        meh - tab      : osascript "${./darwin/tunnelblick.scpt}"
        hyper - tab    : osascript -e $'tell application "Tunnelblick"\ndisconnect all\nend tell'
      '';
  };

  targets.darwin = {
    keybindings = {
      "~b" = "moveWordBackward:";
      "~f" = "moveWordForward:";
      "^a" = "moveToBeginningOfLine:";
      "^e" = "moveToEndOfLine:";
      "~d" = "deleteWordForward:";
      "^w" = "deleteWordBackward:";
      "^u" = "deleteToBeginningOfLine:";
    };
  };
}
