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
        padding = 5;
        font = "monospace 12";
        width = 400;
        height = 200;
        background-color = "#${white}";
        border-color = "#${bright_black}";
        text-color = "#${black}";
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
