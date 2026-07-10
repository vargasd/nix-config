{ pkgs, ... }:
{
  /*
    TODO
      - clipboard (cliphist?)
      - auto dark mode (darkman?)
      - screencast/share (https://github.com/niri-wm/niri/wiki/Important-Software#portals)
  */

  imports = [
    ./default.nix
    ./modules/foot
    ./modules/fuzzel
    ./modules/keyd
    ./modules/mako
    ./modules/niri
    ./modules/swayidle
    ./modules/swaylock
    ./modules/waybar
  ];

  home = {
    sessionVariables = {
      TERMCMD = "${pkgs.foot}/bin/footclient";
      TERMINAL = "${pkgs.foot}/bin/footclient";
      GDK_DEBUG = "portals";
    };
    packages = with pkgs; [
      bluetui
      brightnessctl
      impala
      libnotify
      bemoji
      # needed to insert for bemoji
      wtype
    ];
  };

  xdg = {
    autostart.enable = true;
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "foot.desktop" ];
      };
    };
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-desktop-portal-termfilechooser
      ];
      config.niri = {
        "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
      };
    };

    configFile."xdg-desktop-portal-termfilechooser/config" = {
      enable = true;
      text = ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      '';
    };

    dataFile."bemoji/data.txt" = {
      enable = true;
      text =
        (import ../utils/symbols.nix { inherit pkgs; }).all
        |> builtins.map (data: "${data.emoji} ${data.label}")
        |> builtins.concatStringsSep "\n";
    };

    mimeApps = {
      enable = true;
      defaultApplicationPackages = with pkgs; [
        firefox
        librewolf
      ];
    };

    desktopEntries = {
      yazi = {
        name = "yazi";
        noDisplay = true;
      };
      foot-server = {
        name = "foot server";
        noDisplay = true;
      };
      vim = {
        name = "vim";
        noDisplay = true;
      };
      gvim = {
        name = "gvim";
        noDisplay = true;
      };
      nvim = {
        name = "nvim";
        noDisplay = true;
      };
    };
  };
}
