{ pkgs, ... }:
{
  imports = [
    ./default.nix
  ];

  home.sessionVariables = {
    PUPPETEER_EXECUTABLE_PATH = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser";
  };

  services.gpg-agent.pinentry.package = pkgs.pinentry_mac;

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
