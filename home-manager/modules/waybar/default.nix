{ colors, ... }:
{
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      spacing = 8;
      modules-left = [ "clock" ];
      modules-center = [ "niri/window" ];
      modules-right = [
        "bluetooth"
        "network"
        "wireplumber"
        "battery"
        "custom/power"
      ];
      wireplumber = {
        format = "{icon}";
        format-muted = "";
        format-icons = [
          ""
          ""
          ""
        ];
      };
      network = {
        interface = "wlan0";
        format = "󰲛";
        format-wifi = "";
        format-ethernet = "󰛳";
        tooltip-format = "{ipaddr}/{cidr} {ifname} via {gwaddr}";
        tooltip-format-wifi = "{essid} ({signalStrength}%) ";
        tooltip-format-ethernet = "{ifname} ";
        tooltip-format-disconnected = "Disconnected";
      };
      bluetooth = {
        format = "󰂯";
        format-off = "󰂲";
        format-connected = "󰂱";
        tooltip-format = "{controller_alias}\t{controller_address}";
        tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
      };
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
      "niri/window" = {
        "format" = "{app_id} – {title}";
      };
    };
    style = with colors.named; /* css */ ''
      * {
        font-family: 'JetBrainsMonoNL Nerd Font Propo', monospace;
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

      .modules-center {
        margin: 0 1rem;
      }

      #battery {
        background-color: #${dark_green};
        background-color: #${white};
        color: #${black};
        padding: 0 1rem;
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
