{ lib, colors, ... }:
{
  services.mako = {
    enable = true;
    # this needs to be last to override
    extraConfig = lib.generators.toINI { } {
      "app-name=notify-send".format = "%s\\n\\n%b";
    };
    settings =
      with colors.named;
      let
        format = "(%a) %s\\n\\n%b";
      in
      {
        padding = 20;
        font = "monospace 12";
        width = 350;
        background-color = "#${background}";
        border-color = "#${bright_black}";
        text-color = "#${white}";
        inherit format;
      }
      // (
        # gotta combine all these thingies like mad
        [
          {
            rule = "actionable";
            icon = "󰳽";
          }
          {
            rule = "expiring";
            icon = "";
          }
          {
            rule = "urgency=critical";
            icon = "‼";
          }
        ]
        |> builtins.foldl' (
          acc: conf:
          acc
          // lib.mapAttrs' (rules: val: {
            name = "${rules} ${conf.rule}";
            value.format = "${conf.icon} ${val.format}";
          }) acc
          // {
            "${conf.rule}".format = "${conf.icon} ${format}";
          }
        ) { }
      );
  };
}
