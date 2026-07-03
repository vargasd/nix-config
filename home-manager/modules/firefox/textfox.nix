{ colors, inputs, ... }:
{
  imports = [ inputs.textfox.homeManagerModules.default ];

  textfox = {
    enable = false;
    profiles = [ "default" ];
    config = with colors.named; {
      background.color = "#${background}";
      border = {
        color = "#${bright_black}";
        width = "1px";
        transition = "none";
        radius = "0";
      };
      navbar = {
        margin = "8px 8px 0px 8px";
        padding = "4px";
      };
      displayWindowControls = false;
      displayNavButtons = true;
      displayUrlbarIcons = true;
      displaySidebarTools = false;
      displayTitles = false;
      font = {
        family = "'JetBrains Mono', monospace";
        size = "15px";
        accent = "#${bright_black}";
      };
      tabs.vertical.enable = true;
      bookmarks.alignment = "left";
      icons = {
        toolbar.extensions.enable = true;
        context.extensions.enable = true;
        context.firefox.enable = true;
      };
      extraConfig = /* css */ ''
        findbar {
          order: -1 !important; /* for 113 and newer */
          transition: none !important;
          margin: 0 0 1rem !important
        }
      '';
    };
  };
}
