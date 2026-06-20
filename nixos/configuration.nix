{
  pkgs,
  colors,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  # Use the systemd-boot EFI boot loader.
  # boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "vt.cur_default=0x700010" # solid beam cursor
  ];

  networking.wireless.iwd.enable = true;

  time.timeZone = "America/Indiana/Indianapolis";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "en_DK.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings = {
    LC_TIME = "en_DK.UTF-8"; # ISO 8601
  };

  console = {
    keyMap = "us";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-122b.psf.gz";
    colors = with colors.named; [
      black
      dark_red
      dark_green
      dark_yellow
      dark_blue
      dark_magenta
      dark_cyan
      gray
      bright_black
      red
      green
      yellow
      blue
      magenta
      cyan
      white
    ];
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono NF SemiBold" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "vargasd";
      };
    };
  };

  users.users.vargasd = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "keyd"
      "input"
      "uinput"
    ];
    shell = pkgs.fish;
  };
  # https://github.com/NixOS/nixpkgs/issues/290161
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [ "CAP_SETGID" ];
  systemd.services.keyd.serviceConfig.AmbientCapabilities = [ "CAP_SETGID" ];
  users.groups.keyd = { };

  programs.fish.enable = true;
  programs.zsh.enable = true;

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    LIBSQLITE = "${pkgs.sqlite.out}/lib/libsqlite3.so";
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    git
    psmisc
    wl-clipboard-rs
    keyd
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  services.pcscd.enable = true;

  services.geoclue2.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default.settings = {
      main = {
        capslock = "overload(navmeh, esc)";
        sysrq = "layer(meta)";
        # rightalt acts as altgr by default
        rightalt = "layer(alt)";
      };
      "navmeh:C-A-S" = {
        h = "left";
        j = "down";
        k = "up";
        l = "right";
      };
    };
  };

  hardware.bluetooth.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
