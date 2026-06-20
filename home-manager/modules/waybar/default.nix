{ colors, ... }:
{
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      spacing = 8;
      modules-center = [ "niri/window" ];
      modules-right = [
        "clock"
        "battery"
        "custom/power"
      ];
      battery = {
        format = "{capacity}% {icon}";
        states = {
          not-full = 98;
          warning = 30;
          critical = 10;
        };
        format-icons =
          let
            icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰁹"
            ];
          in
          {
            default = icons;
            charging = icons |> map (icon: "${icon}󱐋");
            fully-charged = icons |> map (icon: "${icon}󱐋");
          };
      };
      clock = {
        format = "{:%Y-%m-%d %H:%M}";
        tooltip = true;
        tooltip-format = "{tz_list}";
        timezones = [
          ""
          "UTC"
        ];
      };
      "custom/power" = {
        format = "󰐥";
        tooltip = false;
        menu = "on-click";
        menu-file = ./power.xml;
        menu-actions = {
          shutdown = "shutdown now";
          reboot = "reboot now";
          suspend = "systemctl suspend";
          hibernate = "systemctl hibernate";
        };
      };
    };
    style = with colors.named; /* css */ ''
      * {
        font-family: 'JetBrainsMonoNL Nerd Font Mono', monospace;
        font-weight: 700;
        font-size: 16px;
        transition: none;
      }

      #waybar {
        background-color: #${background};
        color: #${white};
        border-bottom: 1px solid #${bright_black};
      }

      tooltip, menu {
        border: 1px solid #${bright_black};
        background-color: #${background};
        color: #${white};
      }

      tooltip label {
        color: #${white};
      }

      menuitem:hover {
        color: #${white};
        background-color: #${dark_blue};
      }

      #battery {
        background-color: #${dark_green};
        color: #${black};
        padding: 0 1rem;
      }

      #battery.not-full {
        background-color: #${white};
      }

      #battery.warning:not(.charging) {
        background-color: #${dark_yellow};
      }

      #battery.critical:not(.charging) {
        background-color: #${dark_red};
      }

      #custom-power {
        padding-right: 1rem;
      }
    '';
  };
}
