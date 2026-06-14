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
    package = pkgs.niri-unstable;

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
          length.total-proportion = 0.5;
          place-within-column = true;
          # position = "bottom";
          width = 2;
          active.color = colors.named.magenta;
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
        {
          argv = [
            "${pkgs.keyd}/bin/keyd-application-mapper"
            "-d"
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
          "Alt+Space".action.spawn-sh = ''
            niri msg --json windows | jq '.[] | (.id | tostring) + " " + .app_id + ": " + .title' -r | fuzzel -d | cut -d' ' -f1 | xargs niri msg action focus-window --id
          '';
          "Super+Q" = {
            action.close-window = [ ];
            repeat = false;
          };

          "${meh}+Escape".action.spawn-sh = "${pkgs.mako}/bin/makoctl dismiss --all";
          "${meh}+T".action.spawn-sh =
            "niri msg --json windows | jq 'first(.[] | select(.app_id == \"foot.main\")).layout.pos_in_scrolling_layout[0]' | xargs niri msg action focus-column || niri msg action spawn -- foot --app-id foot.main";
          "${meh}+B".action.spawn-sh = focusOrSpawn "librewolf" (lib.getExe pkgs.librewolf);
          "Super+Shift+8".action.center-column = [ ];
          "Super+Left".action.focus-column-left = [ ];
          "Super+Right".action.focus-column-right = [ ];
          "Super+Down".action.focus-window-down = [ ];
          "Super+Up".action.focus-window-up = [ ];
          "Super+Alt+Left".action.move-column-left = [ ];
          "Super+Alt+Down".action.switch-preset-column-width = [ ];
          "${meh}+Left".action.focus-monitor-left = [ ];
          "${meh}+Down".action.focus-monitor-down = [ ];
          "${meh}+Up".action.focus-monitor-up = [ ];
          "${meh}+Right".action.focus-monitor-right = [ ];
          "${hyper}+Left".action.move-column-to-monitor-left = [ ];
          "${hyper}+Down".action.move-column-to-monitor-down = [ ];
          "${hyper}+Up".action.move-column-to-monitor-up = [ ];
          "${hyper}+Right".action.move-column-to-monitor-right = [ ];
          "Super+Alt+Up".action.maximize-column = [ ];
          "Super+Alt+Right".action.move-column-right = [ ];
          "Super+Comma".action.consume-or-expel-window-left = [ ];
          "Super+Period".action.consume-or-expel-window-right = [ ];
          "${meh}+Delete".action.spawn = "${lib.getExe pkgs.swaylock}";
          "${hyper}+Delete".action.quit.skip-confirmation = true;
          "Ctrl+F1".action.spawn-sh = "foot --app-id foot.main";
          "Ctrl+F2".action.spawn-sh = /* bash */ ''
            dir=$(printf "$HOME\n$(zoxide query --list)" | fuzzel -d)
            wlrctl window focus "app_id:foot.main" "title:$dir" || foot --app-id foot.main --working-directory "$dir" zmx attach "$(basename $dir)#1"
          '';

          "${meh}+5" = {
            allow-when-locked = true;
            action.spawn-sh = "brightnessctl set 10%-";
          };
          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action.spawn-sh = "brightnessctl set 10%-";
          };
          "${meh}+8" = {
            allow-when-locked = true;
            action.spawn-sh = "brightnessctl set 10%+";
          };
          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action.spawn-sh = "brightnessctl set 10%+";
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0";
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          };
          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
          };
          "${meh}+C".action.spawn-sh = ''notify-send "$(date)" -t 3000'';

          "${meh}+U".action.spawn-sh = "${lib.getExe pkgs.bemoji} -t";
          "${meh}+X".action.screenshot = [ ];

          "${meh}+Z".action.screenshot-screen = [ ];
          "${hyper}+Z".action.screenshot-window = [ ];

          "${meh}+Q".action.toggle-window-floating = [ ];
          "${meh}+Home".action.focus-column-first = [ ];
          "${meh}+End".action.focus-column-last = [ ];
          "${meh}+WheelScrollDown".action.focus-column-right = [ ];
          "${meh}+WheelScrollUp".action.focus-column-left = [ ];

          "${meh}+F".action.spawn-sh =
            focusOrSpawn "floating.bluetui" "footclient --app-id foot.floating.bluetui bluetui";
          "${meh}+W".action.spawn-sh =
            focusOrSpawn "floating.impala" "${pkgs.foot}/bin/footclient --app-id foot.floating.impala impala";
          "${meh}+E".action.spawn-sh = focusOrSpawn "foot.yazi" "footclient --app-id foot.yazi yazi";

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
      ];
      extraConfig = ''
        window-rule {
          match app-id="^foot.main$"
          default-column-display "tabbed"
          open-consume-into-column "first"
        }
      '';
    };
  };
}
