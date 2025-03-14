{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.ast-grep
    pkgs.bat
    # pkgs.brave
    pkgs.btop
    pkgs.cmake
    pkgs.clang
    pkgs.eza
    pkgs.delta
    pkgs.fd
    pkgs.fzf
    pkgs.gh
    pkgs.git
    pkgs.gnumake
    pkgs.gnupg
    pkgs.jless
    pkgs.jq
    pkgs.lazygit
    pkgs.less
    pkgs.neofetch
    pkgs.neovim
    pkgs.nodejs
    # pkgs.orcaslicer # not available at all (bambu-studio is but only for linux)
    pkgs.ripgrep
    pkgs.sqlite
    pkgs.stow
    # pkgs.wezterm # undercurl doesn't work. use casks instead
    pkgs.yazi
    pkgs.zoxide

    # TODO Use nix-env for most of these? At least the ones that you don't use all the time
    # language servers
    pkgs.bash-language-server
    pkgs.clang-tools
    pkgs.vscode-langservers-extracted # css, eslint, html, json
    pkgs.efm-langserver
    pkgs.harper
    pkgs.lua-language-server
    pkgs.marksman
    pkgs.nixd
    pkgs.rust-analyzer
    pkgs.terraform-ls
    pkgs.typescript-language-server
    pkgs.vtsls

    # formatters
    pkgs.stylua
    pkgs.prettierd
    pkgs.nixfmt-rfc-style
  ];

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
      };

      screencapture = {
        # location = "~/Desktop" # but we need the user so...
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
      };
      #TODO night shift? https://github.com/LnL7/nix-darwin/issues/1046
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
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
