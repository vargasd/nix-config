{ home, ... }:
{
  homebrew = {
    enable = true;
    brews = [ ];
    casks = [
      "brave-browser"
      "homerow"
      "orcaslicer"
      "notunes"
      "rectangle"
      "wezterm" # needed for terminfo
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

  nix.enable = false;

  time.timeZone = "America/Indiana/Indianapolis";

  system = {
    primaryUser = home.user;
    configurationRevision = null;
    stateVersion = 6;
    startup.chime = false;
  };

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    watchIdAuth = true;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
