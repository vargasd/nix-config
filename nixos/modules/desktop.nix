{ pkgs, ... }:
{
  imports = [
    ./base.nix
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "vargasd";
      };
    };
  };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  services.keyd = {
    enable = true;
    keyboards.default.settings = {
      main = {
        capslock = "overload(navmeh, esc)";
        sysrq = "layer(meta)";
        # rightalt acts as altgr by default
        rightalt = "layer(alt)";
      };
      "navmeh:C-A-S" = {
        h = "left";
        j = "down";
        k = "up";
        l = "right";
      };
      "alt" = {
        b = "C-left";
        f = "C-right";
      };
      # always prefer meh
      "control+alt+shift" = {
        b = "C-A-S-b";
        f = "C-A-S-f";
      };
    };
  };

  hardware.bluetooth.enable = true;
}
