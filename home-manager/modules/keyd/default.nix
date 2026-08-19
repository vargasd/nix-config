{ pkgs, lib, ... }:
{
  xdg.configFile."keyd/app.conf" = {
    enable = true;
    text = pkgs.lib.generators.toINI { } {
      "foot-main" = {
        "meta.t" = "C-f1";
        "meta.s" = "C-f2";
      };
      "ghostty-main" = {
        "meta.s" = "C-f4";
      };
      slack = {
        "meta.k" = "C-k";
        "meta.a" = "C-a";
        "meta.f" = "C-f";
        "meta.enter" = "C-enter";
      };
    };
  };

  systemd.user.services.keyd-application-mapper = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit = {
      After = "graphical-session.target";
      Description = "keyd application mapper";
      Documentation = [ "man:keyd-application-mapper(1)" ];
      PartOf = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      ExecStart = lib.getExe' pkgs.keyd "keyd-application-mapper";
      Restart = "always";
    };
  };
}
