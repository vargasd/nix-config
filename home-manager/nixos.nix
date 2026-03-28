{
  pkgs,
  inputs,
  lib,
  colors,
  symbols,
  ...
}:
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
    ./modules/niri
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

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    clearDefaultKeybinds = true;
    settings = with colors; {
      background = named.background;
      foreground = named.white;
      palette = colors.indexed |> lib.lists.imap0 (i: v: "${builtins.toString i} = ${v}");
      cursor-color = named.white;
      split-divider-color = named.bright_black;
      cursor-style-blink = false;
      cursor-style = "block";
      mouse-hide-while-typing = true;
      shell-integration-features = "no-cursor";
      selection-foreground = "cell-background";
      selection-background = "cell-foreground";
      # TODO enable after updating
      # search-foreground = named.black;
      # search-background = named.dark_yellow;
      # search-selected-foreground = named.black;
      # search-selected-background = named.yellow;
      bell-features = "no-title no-attention";
      font-size = 16;
      window-decoration = "none";
      window-show-tab-bar = "never";
      keybind =
        {
          "super+t" = "new_tab";
          "super+s" = "toggle_tab_overview";
          "super+c" = "copy_to_clipboard";
          "super+v" = "paste_from_clipboard";
          "alt+asterisk" = "toggle_split_zoom";
          "alt+arrow_right" = "goto_split:right";
          "alt+arrow_left" = "goto_split:left";
          "alt+arrow_down" = "goto_split:down";
          "alt+arrow_up" = "goto_split:up";
          "alt+shift+arrow_right" = "new_split:right";
          "alt+shift+arrow_left" = "new_split:left";
          "alt+shift+arrow_down" = "new_split:down";
          "alt+shift+arrow_up" = "new_split:up";
          "ctrl+shift+x" = "write_scrollback_file:open";
        }
        |> lib.attrsets.attrsToList
        |> builtins.map (kv: "${kv.name}=${kv.value}");
    };
    # systemd.enable = true;
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
    settings = {
      main = {
        font = "monospace:size=15";
      };
      colors =
        with colors.named;
        {
          background = background;
          text = white;
          message = white;
          prompt = magenta;
          placeholder = bright_black;
          input = white;
          match = magenta;
          selection = bright_black;
          selection-text = white;
          selection-match = magenta;
          border = bright_black;
        }
        |> builtins.mapAttrs (n: val: "${val}ff");
      border.radius = 0;
    };
  };

  services.mako = {
    enable = true;
    # this needs to be last to override
    extraConfig = lib.generators.toINI { } {
      "app-name=notify-send".format = "%s\\n\\n%b";
    };
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
          # put all GUI apps here; apparently the only way to get fuzzel working
          application."only" = [
            "firefox"
          ];
          exact_match = true;
          remap = {
            "ctrl-a" = "home";
            "ctrl-e" = "end";
            "alt-b" = "ctrl-left";
            "alt-f" = "ctrl-right";
            "shift-ctrl-a" = "shift-home";
            "shift-ctrl-e" = "shift-end";
            "shift-alt-b" = "shift-ctrl-left";
            "shift-alt-f" = "shift-ctrl-right";

            "ctrl-w" = "ctrl-backspace";
            # TODO fix ctrl-u for fuzzel application.not doesn't work
            "ctrl-u" = [
              "shift-home"
              "backspace"
            ];
          };
        }
      ];
    };
  };

  services.swayidle =
    let
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
      lockTime = 300;
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = lockTime - 20;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 20 seconds' -t 20000";
        }
        {
          timeout = lockTime;
          command = lock;
        }
        {
          timeout = 1200;
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 3600;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = {
        before-sleep = "${display "off"}; ${lock}";
        after-resume = display "on";
        lock = "${display "off"}; ${lock}";
        unlock = display "on";
      };
    };
}
