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

  # Use the systemd-boot EFI boot loader.
  # boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "vt.cur_default=0x700010" # solid beam cursor
  ];

  networking.hostName = "nuc";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Indiana/Indianapolis";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Bold.ttf";
    keyMap = "us";
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
    enableDefaultPackages = false;
    packages = with pkgs; [
      jetbrains-mono
      noto-fonts-monochrome-emoji
      dejavu_fonts
      freefont_ttf
      gyre-fonts
      liberation_ttf
      unifont
      nerd-fonts.jetbrains-mono
    ];
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono NF SemiBold" ];
      emoji = [ "Noto Emoji" ];
    };
  };

  services = {
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
          user = "vargasd";
        };
      };
    };
  };

  users.users.vargasd = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "sudo"
    ];
    shell = pkgs.zsh;
  };

  services.xremap = {
    enable = true;
    withNiri = true;
    serviceMode = "user";
    userName = "vargasd";
    # config is done in home-manager (but this is required)
    config.keymap = [ ];
  };

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
    wl-clipboard-rs
  ];

  programs.niri.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.geoclue2.enable = true;

  hardware.bluetooth.enable = true;
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
