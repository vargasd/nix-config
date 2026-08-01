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
    };
  };

  hardware.bluetooth.enable = true;
}
