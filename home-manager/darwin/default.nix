{
  services.skhd = {
    enable = true;
    config =
      builtins.readFile ./skhdrc
      + ''
        meh - escape   : osascript "${./clear-notifications.scpt}"
        meh - tab      : osascript "${./tunnelblick.scpt}"
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
