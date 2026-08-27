{ pkgs, ... }:
{
  services.swayidle =
    let
      lock = "gpg-connect-agent reloadagent /bye; ${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
      plugged = "${pkgs.pmutils}/bin/on_ac_power";
      lockTime = 1200;
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
          timeout = 3600;
          command = "${plugged} && ${display "off"} || systemctl suspend";
          resumeCommand = display "on";
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
