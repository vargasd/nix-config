{ pkgs, ... }:
{
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
          timeout = lockTime * 2;
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
