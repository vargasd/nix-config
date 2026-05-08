{
  home,
  pkgs,
  lib,
  ...
}:
{
  homebrew = {
    enable = true;
    enableZshIntegration = true;
    brews = [ "neurosnap/tap/zmx" ];
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
  };

  users.users.${home.user} = {
    home = home.homeDirectory;
  };

  environment.shells = [
    pkgs.zsh
  ];

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
