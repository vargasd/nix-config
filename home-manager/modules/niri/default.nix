{
  pkgs,
  lib,
  inputs,
  colors,
  ...
}:
{
  imports = [
    inputs.niri-flake.homeModules.niri
  ];
  programs.niri = {
    enable = true;

    settings = {
      input.keyboard.repeat-delay = 200;
      layout = {
        default-column-width.proportion = 0.5;
        gaps = 2;
        focus-ring = {
          enable = true;
          width = 2;
          active.color = colors.named.blue;
          inactive.color = colors.named.gray;
          urgent.color = colors.named.red;
        };
        tab-indicator = {
          hide-when-single-tab = true;
          gap = 0;
          gaps-between-tabs = 2;
          length.total-proportion = 0.8;
          place-within-column = true;
          # position = "bottom";
          width = 2;
          active.color = colors.named.yellow;
          inactive.color = colors.named.bright_black;
          urgent.color = colors.named.red;
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
            "3000"
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
          "${meh}+T".action.spawn-sh =
            "niri msg --json windows | jq 'first(.[] | select(.app_id == \"foot.main\")).layout.pos_in_scrolling_layout[0]' | xargs niri msg action focus-column || niri msg action spawn -- foot --app-id foot.main";
          "${meh}+B".action.spawn-sh = focusOrSpawn "firefox" (lib.getExe pkgs.firefox);
          "Super+Left".action.focus-column-left = [ ];
          "Super+Right".action.focus-column-right = [ ];
          "Super+Down".action.focus-window-down = [ ];
          "Super+Up".action.focus-window-up = [ ];
          "Super+Alt+Left".action.move-column-left = [ ];
          "Super+Alt+Down".action.switch-preset-column-width = [ ];
          "Super+Alt+Up".action.maximize-column = [ ];
          "${hyper}+Right".action.move-column-right = [ ];
          "${meh}+Delete".action.spawn = "${lib.getExe pkgs.swaylock}";
          "${hyper}+Delete".action.quit.skip-confirmation = true;

          "${meh}+percent" = {
            allow-when-locked = true;
            action.spawn-sh = "brightnessctl set 10%-";
          };
          "${meh}+asterisk" = {
            allow-when-locked = true;
            action.spawn-sh = "brightnessctl set 10%+";
          };

          "${meh}+U".action.spawn-sh = "${lib.getExe pkgs.bemoji} -t";
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
            focusOrSpawn "title:floating.bluetui" "${pkgs.foot}/bin/footclient --app-id foot.floating.bluetui ${lib.getExe pkgs.bluetui}";

          "${meh}+W".action.spawn-sh =
            focusOrSpawn "title:floating.impala" "${pkgs.foot}/bin/footclient --app-id foot.floating.impala ${lib.getExe pkgs.impala}";

          "${hyper}+Home".action.move-column-to-first = [ ];
          "${hyper}+End".action.move-column-to-last = [ ];
          "${hyper}+C".action.center-visible-columns = [ ];
          "${hyper}+WheelScrollDown".action.move-column-right = [ ];
          "${hyper}+WheelScrollUp".action.move-column-left = [ ];
        };

      window-rules = [
        {
          matches = [ { app-id = "^foot.floating."; } ];
          open-floating = true;
          default-column-width.fixed = 1200;
          default-window-height.proportion = 0.7;
          open-focused = true;
        }
        {
          matches = [ { app-id = "^foot.main$"; } ];
          default-column-display = "tabbed";
        }
      ];
    };
  };
}
