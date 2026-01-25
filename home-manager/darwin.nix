{
  pkgs,
  inputs,
  home,
  lib,
  ...
}:
{
  imports = [
    ./default.nix
  ];

  home = {
    packages = with pkgs; [
      defaultbrowser
    ];

    sessionVariables = {
      LIBSQLITE = "${pkgs.sqlite.out}/lib/libsqlite3.dylib";
    };

    activation = {
      defaultbrowser = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${pkgs.defaultbrowser}/bin/defaultbrowser browser
      '';
    };
  };

  services.gpg-agent.pinentry.package = pkgs.pinentry_mac;

  services.skhd = {
    enable = true;
    config = builtins.readFile ./darwin/skhdrc + ''
      meh - escape : osascript "${inputs.clear-notifications}/close_notifications_applescript.js"
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

    defaults = {
      "com.apple.dock" = {
        autohide = true;
        autohide-delay = 0.0;
        magnification = true;
        show-recents = false;
        tilesize = 16;
        persistent-apps = [ ];
      };

      "com.apple.finder" = {
        # TODO manage favorites?
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv"; # this doesn't seem to work
        FXRemoveOldTrashItems = true;
        NewWindowTarget = "Home";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXSortFoldersFirst = true;
      };

      "com.apple.menuextra.clock".Show24Hour = true;

      "com.apple.screencapture" = {
        location = "Desktop";
        show-thumbnail = true;
        type = "png";
      };

      # disable most spotlight junk (only enable apps and settings)
      "com.apple.Spotlight".EnabledPreferenceRules = [
        "Custom.relatedContents"
        "System.files"
        "System.folders"
        "System.iphoneApps"
        "System.menuItems"
        "com.apple.AppStore"
        "com.apple.iBooksX"
        "com.apple.calculator"
        "com.apple.iCal"
        "com.apple.AddressBook"
        "com.apple.Dictionary"
        "com.apple.mail"
        "com.apple.Notes"
        "com.apple.Photos"
        "com.apple.podcasts"
        "com.apple.reminders"
        "com.apple.Safari"
        "com.apple.shortcuts"
        "com.apple.tips"
        "com.apple.VoiceMemos"
      ];

      # disable spotlight sharing
      "com.apple.assistant.support"."Search Queries Data Sharing Status" = 2;

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        KeyRepeat = 2;
        AppleEnableMouseSwipeNavigateWithScrolls = false;
        AppleEnableSwipeNavigateWithScrolls = false;
        InitialKeyRepeat = 15;
        AppleICUForce24HourTime = true;
        "com.apple.swipescrolldirection" = false;
        "com.apple.sound.beep.volume" = 0.0;
        NSScrollAnimationEnabled = false;
        ApplePressAndHoldEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };

      "com.knollsoft.Rectangle" = {
        launchOnLogin = true;
        gapSize = 0;
        almostMaximizeHeight = 0.75;
        almostMaximizeWidth = 0.6;
        hideMenuBarIcon = true;
        cycleSizesIsChanged = true;
        selectedCycleSizes = 18; # 2^1 + 2^4 -> https://github.com/rxhanson/Rectangle/blob/main/Rectangle/CycleSize.swift
        subsequentExecutionMode = 0; # resize on repeat
      };

      "com.superultra.Homerow" = {
        "label-characters" = "sarteionmgdczvuyhkjlfwqb";
        "label-font-size" = 16;
        "launch-at-login" = true;
        "show-menubar-icon" = false;
        # not working -- this is the value set from the app, but it gets converted to the second line
        # "non-search-shortcut" = builtins.fromJSON ''"\\U2303\\U2325\\U21e7F"''; # meh-f
        # "\\U2303\\U2325\\Ud847\\Ude7f"

      };

      # night shift https://github.com/LnL7/nix-darwin/issues/1046
      "com.apple.CoreBrightness.plist" =
        let
          userId = builtins.readFile (
            pkgs.runCommand "user-id" { }
              "/usr/bin/dscl . -read /Users/${home.user} GeneratedUID | /usr/bin/sed 's/GeneratedUID: //' | /usr/bin/tr -d \\\\n > $out"
          );
        in
        {
          "CBUser-${userId}" = {
            CBBlueLightReductionCCTTargetRaw = "3393.025";
            CBBlueReductionStatus = {
              AutoBlueReductionEnabled = 1;
              BlueLightReductionDisableScheduleAlertCounter = 3;
              BlueLightReductionSchedule = {
                DayStartHour = 7;
                DayStartMinute = 0;
                NightStartHour = 22;
                NightStartMinute = 0;
              };
              BlueReductionAvailable = 1;
              BlueReductionEnabled = 1;
              BlueReductionMode = 1;
              BlueReductionSunScheduleAllowed = 1;
              Version = 1;
            };
          };
        };

      # See https://apple.stackexchange.com/a/474905
      "com.apple.symbolichotkeys".AppleSymbolicHotKeys =
        let
          # https://gist.github.com/stephancasas/74c4621e2492fb875f0f42778d432973
          none = 65535;
          command = 1048576;
          hyper = 1966080;
          meh = 917504;
          option = 524288;
        in
        {
          # meh - z to screenshot
          "28" = {
            enabled = true;
            value = {
              parameters = [
                none
                6
                meh
              ];
              type = "standard";
            };
          };
          # meh - x to screenshot region
          "30" = {
            enabled = true;
            value = {
              parameters = [
                none
                7
                meh
              ];
              type = "standard";
            };
          };
          # hyper - x to show screenshot options
          "184" = {
            enabled = true;
            value = {
              parameters = [
                none
                7
                hyper
              ];
              type = "standard";
            };
          };
          # option-tab to switch app window
          "27" = {
            enabled = true;
            value = {
              parameters = [
                none
                48
                option
              ];
              type = "standard";
            };
          };
          # disable ctrl-up/down
          "32" = {
            enabled = false;
          };
          "33" = {
            enabled = false;
          };
          # disable spotlight
          "64" = {
            enabled = true;
          };
        };

      NSGlobalDomain = {
        NSUserKeyEquivalents = {
          # meh-f16 to minimize (really just disabling cmd-m minimize)
          Minimize = "~^$\\Uf713";
        };
        CGDisableCursorLocationMagnification = true;
      };

      "digital.twisted.noTunes" = {
        hideIcon = true;
      };
    };
  };
}
