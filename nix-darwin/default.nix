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
      skhdConfig = builtins.readFile ./skhdrc;
    };
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
