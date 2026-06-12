{
  home,
  pkgs,
  ...
}:
{
  homebrew = {
    enable = true;
    enableZshIntegration = true;
    # TODO uncomment after https://github.com/nix-darwin/nix-darwin/pull/1789
    # brews = [ "neurosnap/tap/zmx" ];
    taps = [ "neurosnap/tap" ];
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
      # TODO remove after https://github.com/nix-darwin/nix-darwin/pull/1789
      extraFlags = [ "--force-cleanup" ];
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
