{
  pkgs,
  inputs,
  lib,
  colors,
  ...
}:
{
  /*
    TODO
      - input
        - compose key
        - emoji picker (bemoji?)
      - foot/ghostty as primary terminal
        - tabbing rule (do we need stacking?)
        - fuzzel switcher (open window jumping + zoxide to open new instance?)
        - neovim scrollback
      - clipboard (cliphist?)
      - auto dark mode (darkman?)
      - screencast/share (https://github.com/niri-wm/niri/wiki/Important-Software#portals)
    FIXME
      - colorless noto emoji
  */

  imports = [
    ./default.nix
    inputs.niri-flake.homeModules.niri
    inputs.xremap.homeManagerModules.default
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
  };

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "monospace:size=16";
      };
      cursor = {
        blink = false;
        blink-rate = 0;
      };
      colors =
        with colors.named;
        {
          background = background;
          foreground = white;
          regular0 = black;
          regular1 = dark_red;
          regular2 = dark_green;
          regular3 = dark_yellow;
          regular4 = dark_blue;
          regular5 = dark_magenta;
          regular6 = dark_cyan;
          regular7 = gray;
          bright0 = bright_black;
          bright1 = red;
          bright2 = green;
          bright3 = yellow;
          bright4 = blue;
          bright5 = magenta;
          bright6 = cyan;
          bright7 = white;
        }
        // builtins.listToAttrs (
          builtins.genList (i: {
            name = toString (i + 16);
            value = builtins.elemAt colors.indexed (i + 16);
          }) 240
        );
    };
  };

  programs.niri = {
    enable = true;

    settings = {
      input.keyboard.repeat-delay = 200;
      layout = {
        gaps = 4;
        focus-ring = {
          enable = true;
          width = 4;
        };
      };

      spawn-at-startup = [
        {
          argv = [
            (lib.getExe pkgs.foot)
            "--server"
          ];
        }
        {
          argv = [
            (lib.getExe pkgs.wlsunset)
            "-l"
            "39.9"
            "-L"
            "-86.1"
            "-t"
            "3500"
            "-T"
            "5500"
          ];
        }
      ];
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      screenshot-path = "/tmp/screenshot_%Y-%m-%dT%H-%M-%S.png";
      animations.enable = false;

      binds =
        let
          meh = "Alt+Ctrl+Shift";
          hyper = "${meh}+Super";
          focusOrSpawn =
            winmatch: exe:
            "${lib.getExe pkgs.wlrctl} window focus ${winmatch} || niri msg action spawn -- ${exe}";
        in
        {
          "Ctrl+Up" = {
            action.toggle-overview = [ ];
            repeat = false;
          };
          "Super+Space".action.spawn = lib.getExe pkgs.fuzzel;
          "Super+Q" = {
            action.close-window = [ ];
            repeat = false;
          };

          "${meh}+Escape".action.spawn-sh = "${pkgs.mako}/bin/makoctl dismiss --all";
          "${meh}+T".action.spawn-sh = focusOrSpawn "foot" (lib.getExe pkgs.foot);
          "${meh}+B".action.spawn-sh = focusOrSpawn "firefox" (lib.getExe pkgs.firefox);
          "${meh}+Left".action."focus-column-left" = [ ];
          "${meh}+Right".action."focus-column-right" = [ ];
          "${meh}+Down".action.switch-preset-column-width = [ ];
          "${meh}+Up".action.maximize-column = [ ];
          "${hyper}+Left".action.move-column-left = [ ];
          "${hyper}+Down".action.move-window-down = [ ];
          "${hyper}+Up".action.move-window-up = [ ];
          "${hyper}+Right".action.move-column-right = [ ];
          "${meh}+Delete".action.spawn = "${lib.getExe pkgs.swaylock}";
          "${hyper}+Delete".action.quit.skip-confirmation = true;

          # FIXME these don't work
          "${meh}+percent" = {
            allow-when-locked = true;
            action.spawn-sh = "brightnessctl --class=backlight set -10%";
          };
          "${meh}+asterisk" = {
            allow-when-locked = true;
            action.spawn-sh = "brightnessctl --class=backlight set +10%";
          };

          "${meh}+X".action.screenshot = [ ];

          "${meh}+Z".action.screenshot-screen = [ ];
          "${hyper}+Z".action.screenshot-window = [ ];

          "${meh}+C".action.center-column = [ ];
          "${meh}+Q".action.toggle-window-floating = [ ];
          "${meh}+Home".action.focus-column-first = [ ];
          "${meh}+End".action.focus-column-last = [ ];
          "${meh}+WheelScrollDown".action.focus-column-right = [ ];
          "${meh}+WheelScrollUp".action.focus-column-left = [ ];

          "${meh}+F".action.spawn-sh =
            focusOrSpawn "title:floating.bluetui" "${pkgs.foot}/bin/footclient -T floating.bluetui ${lib.getExe pkgs.bluetui}";

          "${meh}+W".action.spawn-sh =
            focusOrSpawn "title:floating.impala" "${pkgs.foot}/bin/footclient -T floating.impala ${lib.getExe pkgs.impala}";

          "${hyper}+Home".action.move-column-to-first = [ ];
          "${hyper}+End".action.move-column-to-last = [ ];
          "${hyper}+C".action.center-visible-columns = [ ];
          "${hyper}+WheelScrollDown".action.move-column-right = [ ];
          "${hyper}+WheelScrollUp".action.move-column-left = [ ];
        };

      window-rules = [
        {
          matches = [
            {
              app-id = "foot";
              title = "floating";
            }
          ];
          open-floating = true;
          default-column-width.proportion = 0.4;
          default-window-height.proportion = 0.7;
          open-focused = true;
        }
      ];
    };
  };

  programs.swaylock = {
    enable = true;
    settings = with colors.named; {
      font = "monospace";
      color = background;
      font-size = 16;
      indicator-radius = 100;
      indicator-thickness = 15;
      disable-caps-lock-text = true;
      key-hl-color = magenta;
      ring-color = white;
      text-color = white;
      text-ver-color = white;
      text-wrong-color = white;
      text-clear-color = white;
      inside-clear-color = dark_yellow;
      ring-clear-color = yellow;
      ring-ver-color = blue;
      inside-ver-color = dark_blue;
      ring-wrong-color = red;
      inside-wrong-color = dark_red;
    };
  };

  programs.fuzzel = {
    enable = true;
  };

  services.mako = {
    enable = true;
    # this needs to be last to override
    extraConfig = ''
      [app-name=notify-send]
      format=%s\n\n%b
    '';
    settings =
      with colors.named;
      let
        format = "(%a) %s\\n\\n%b";
      in
      {
        padding = 20;
        font = "monospace 12";
        width = 350;
        background-color = "#${background}";
        border-color = "#${bright_black}";
        text-color = "#${white}";
        inherit format;
      }
      // (
        # gotta combine all these thingies like mad
        [
          {
            rule = "actionable";
            icon = "󰳽";
          }
          {
            rule = "expiring";
            icon = "";
          }
          {
            rule = "urgency=critical";
            icon = "‼";
          }
        ]
        |> builtins.foldl' (
          acc: conf:
          acc
          // lib.mapAttrs' (rules: val: {
            name = "${rules} ${conf.rule}";
            value.format = "${conf.icon} ${val.format}";
          }) acc
          // {
            "${conf.rule}".format = "${conf.icon} ${format}";
          }
        ) { }
      );
  };

  services.xremap = {
    enable = true;
    withNiri = true;
    config = {
      keymap = [
        {
          name = "emacs keys";
          application.not = [
            "foot"
            "footclient"
            "org.wezfurlong.wezterm"
          ];
          remap = {
            "ctrl-a".with_mark = "home";
            "ctrl-e".with_mark = "end";
            "alt-b".with_mark = "ctrl-left";
            "alt-f".with_mark = "ctrl-right";
            "ctrl-w" = "ctrl-backspace";
            "ctrl-u" = [
              "shift-home"
              "backspace"
            ];
          };
        }
      ];
    };
  };

}
