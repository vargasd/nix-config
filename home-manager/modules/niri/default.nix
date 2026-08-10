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
    inputs.niri-autoselect-portal.homeManagerModules.default
    ./keybinds.nix
  ];

  services.niri-autoselect-portal.enable = true;
  services.pass-secret-service.enable = true;
  # https://github.com/sodiboo/niri-flake/issues/1801
  services.gnome-keyring.enable = lib.mkForce false;

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;

    settings = {
      input.keyboard.repeat-delay = 200;
      layout = with colors.named; {
        default-column-width.proportion = 0.5;
        default-column-display = "tabbed";
        background-color = background;
        gaps = 3;
        focus-ring = {
          enable = true;
          width = 2;
          active.color = gray;
          inactive.color = bright_black;
          urgent.color = red;
        };
        tab-indicator = {
          hide-when-single-tab = true;
          gap = 0;
          gaps-between-tabs = 2;
          length.total-proportion = 0.5;
          place-within-column = true;
          # position = "bottom";
          width = 3;
          active.color = magenta;
          inactive.color = bright_black;
          urgent.color = red;
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
        { argv = [ (lib.getExe pkgs.waybar) ]; }
      ];
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      screenshot-path = "/tmp/screenshot_%Y-%m-%dT%H-%M-%S.png";
      animations.enable = false;

      window-rules = with colors.named; [
        {
          matches = [ { app-id = "^foot.floating."; } ];
          open-floating = true;
          default-column-width.fixed = 1200;
          default-window-height.proportion = 0.7;
          open-focused = true;
        }
        {
          matches = [ { is-window-cast-target = true; } ];
          focus-ring = {
            active.color = red;
            inactive.color = dark_red;
          };
          tab-indicator = {
            active.color = dark_red;
            inactive.color = dark_red;
          };
        }
      ];
      extraConfig = /* kdl */ ''
        window-rule {
          match app-id="^(foot|ghostty).main$"
          open-consume-into-column "first"
        }
      '';
    };
  };
}
