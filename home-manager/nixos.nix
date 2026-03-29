{ pkgs, ... }:
{
  /*
    TODO
      - input
        - compose key
      - foot/ghostty as primary terminal
        - tabbing rule (do we need stacking?)
        - fuzzel switcher (open window jumping + zoxide to open new instance?)
        - neovim scrollback
      - clipboard (cliphist?)
      - auto dark mode (darkman?)
      - screencast/share (https://github.com/niri-wm/niri/wiki/Important-Software#portals)
  */

  imports = [
    ./default.nix
    ./modules/foot
    ./modules/fuzzel
    ./modules/mako
    ./modules/niri
    ./modules/swayidle
    ./modules/swaylock
    ./modules/xremap
  ];

  home = {
    sessionVariables = {
      TERMCMD = "${pkgs.foot}/bin/footclient -T floating.yazi";
      GDK_DEBUG = "portals";
    };
    packages = with pkgs; [
      bluetui
      brightnessctl
      impala
      wlrctl
      libnotify
      bemoji
      # needed to insert for bemoji
      wtype
    ];
  };

  xdg = {
    autostart.enable = true;
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
  };
}
