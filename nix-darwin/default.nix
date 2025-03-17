{ pkgs, ... }:
let
  user = "sam";
in
{
  environment = {
    systemPackages = with pkgs; [
      ast-grep
      bat
      # brave
      btop
      cmake
      clang
      defaultbrowser
      eza
      delta
      fd
      fzf
      fzf-git-sh
      gh
      git
      gnumake
      gnupg
      jless
      jq
      lazygit
      less
      neofetch
      neovim
      nodejs
      # orcaslicer # not available at all (bambu-studio is but only for linux)
      ripgrep
      sqlite
      stow
      tmux # TODO There was an error in fzf-git-sh if tmux isn't installed, which doesn't feel right
      # wezterm # undercurl doesn't work. use casks instead
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
      rust-analyzer
      terraform-ls
      typescript-language-server
      vtsls

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
    casks = [
      "orcaslicer"
      "brave-browser"
      "homerow"
      "orcaslicer"
      "rectangle"
      "spotify"
      "wezterm"
    ];
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

  power = {
    restartAfterPowerFailure = true;
  };

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

      NSGlobalDomain = {
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        "com.apple.swipescrolldirection" = false;
        "com.apple.sound.beep.volume" = 0.0;
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
        show-thumbnail = false;
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
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    activationScripts = {
      # Inspired by https://tommorris.org/posts/2024/til-setting-default-browser-on-macos-using-nix/
      postUserActivation.text = "defaultbrowser browser"; # this is brave I guess 🤷
    };
  };

  services = {
    skhd = {
      enable = true;
      skhdConfig = ''
        #meh - q        : open -a qutebrowser
        meh - e        : open -a finder
        meh - v        : open -a 'Google Meet'
        meh - c        : open -a 'Google Calendar'
        meh - s        : open -a slack
        hyper - d      : open -a 'Visual Studio Code'
        meh - m        : open -a spotify
        hyper - m      : open -a messages
        meh - p        : open -a 1password
        hyper - p      : open -a passwords
        meh - i        : open -a linear # https://linear.app
        hyper - i      : open -a "iPhone Mirroring"

        meh - t        : open -a wezterm
        hyper - t      : open -a ghostty

        meh - b        : open -a "Brave Browser" --args --disable-smooth-scrolling
        hyper - b      : open -a safari

        meh - escape   : osascript "${
          pkgs.fetchFromGitHub {
            owner = "Ptujec";
            repo = "LaunchBar";
            rev = "37360ee44155ae429bdb7f492ae66691816d3bb9";
            hash = "sha256-osOWmpqSfgs96dkr3jy+0X+hMUmwFkIIDpDvbkC7EEI=";
          }
          + "/Notifications/macOS 15.1/Dismiss all notifications.lbaction/Contents/Scripts/default.applescript"
        }"

        meh - delete   : open -a ScreenSaverEngine

        hyper - left   : open -g "rectangle://execute-action?name=previous-display"
        hyper - up     : open -g "rectangle://execute-action?name=larger"
        hyper - down   : open -g "rectangle://execute-action?name=smaller"
        hyper - right  : open -g "rectangle://execute-action?name=next-display"
        meh - left     : open -g "rectangle://execute-action?name=left-half"
        meh - up       : open -g "rectangle://execute-action?name=maximize"
        meh - right    : open -g "rectangle://execute-action?name=right-half"
        meh - down     : open -g "rectangle://execute-action?name=almost-maximize"

        fn - h         : skhd -k left
        fn - j         : skhd -k down
        fn - k         : skhd -k up
        fn - l         : skhd -k right
      '';
    };
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
