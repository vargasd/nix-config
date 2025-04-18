{ pkgs, user, ... }:
{
  environment = {
    systemPackages =
      with pkgs;
      let
        gdk = pkgs.google-cloud-sdk.withExtraComponents (
          with pkgs.google-cloud-sdk.components;
          [
            gke-gcloud-auth-plugin
          ]
        );
      in
      [
        ast-grep
        bat
        # brave
        btop
        clang
        defaultbrowser
        delta
        docker
        eza
        fd
        fzf
        fzf-git-sh
        gdk
        gh
        git
        gnupg
        jless
        jq
        lazygit
        lazydocker
        less
        k9s
        kubectl
        neofetch
        neovim
        nodejs
        openapi-tui
        (pkgs.pass.withExtensions (exts: [ exts.pass-otp ]))
        postgresql
        ripgrep
        ruby
        sqlite
        tmux # TODO There was an error in fzf-git-sh if tmux isn't installed, which doesn't feel right
        yazi
        zoxide

        # TODO Use nix-env for most of these? At least the ones that you don't use all the time
        # language servers
        bash-language-server
        clang-tools
        vscode-langservers-extracted # css, eslint, html, json
        efm-langserver
        harper
        lua-language-server
        marksman
        nixd
        phpactor
        postgres-lsp
        rust-analyzer
        terraform-ls
        typescript-language-server
        vtsls
        vue-language-server
        yaml-language-server

        # formatters
        stylua
        prettierd
        nixfmt-rfc-style
      ];

    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      LIBSQLITE = "${pkgs.sqlite.out}/lib/libsqlite3.dylib";
    };
  };

  homebrew = {
    enable = true;
    taps = [ "edosrecki/tools" ];
    brews = [
      "edosrecki/tools/google-cloud-redis"
      "edosrecki/tools/google-cloud-sql"
    ];
    casks = [
      "brave-browser"
      "docker"
      "homerow"
      "orcaslicer"
      "notunes"
      "rectangle"
      "spotify"
      "ueli"
      "wezterm" # needed because emoji finder crashes and for terminfo
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    caskArgs = {
      no_quarantine = true;
    };
  };

  fonts.packages = [ pkgs.jetbrains-mono ];

  # Necessary for using flakes on this system.
  nix = {
    settings.experimental-features = "nix-command flakes";

    gc = {
      automatic = true;
      interval = {
        Hour = 0;
        Minute = 0;
        Weekday = 0;
      };
    };
  };

  time.timeZone = "America/Indiana/Indianapolis";

  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;

    startup.chime = false;

    defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        magnification = true;
        show-recents = false;
        tilesize = 16;
        persistent-apps = [ ];
      };

      finder = {
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

      menuExtraClock.Show24Hour = true;
      loginwindow.autoLoginUser = user;

      NSGlobalDomain = {
        AppleEnableMouseSwipeNavigateWithScrolls = false;
        AppleEnableSwipeNavigateWithScrolls = false;
        InitialKeyRepeat = 15;
        AppleICUForce24HourTime = true;
        KeyRepeat = 2;
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

      screencapture = {
        location = "/Users/${user}/Desktop";
        show-thumbnail = true;
        type = "png";
      };

      CustomUserPreferences = {
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
                "/usr/bin/dscl . -read /Users/${user} GeneratedUID | /usr/bin/sed 's/GeneratedUID: //' | /usr/bin/tr -d \\\\n > $out"
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
            #https://gist.github.com/stephancasas/74c4621e2492fb875f0f42778d432973
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
                  122
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
                  120
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
                  120
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
                  9
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
              enabled = false;
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
          replacement = "/Applications/Spotify.app";
        };
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    activationScripts = {
      # Inspired by https://tommorris.org/posts/2024/til-setting-default-browser-on-macos-using-nix/
      postUserActivation.text = "defaultbrowser browser";
    };
  };

  services = {
    skhd = {
      enable = true;
      skhdConfig =
        builtins.readFile ./skhdrc
        + ''
          meh - escape   : osascript "${./clear-notifications.scpt}"
        ''

      ;
    };
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
