{ colors, lib, ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    clearDefaultKeybinds = true;
    settings = with colors; {
      background = named.background;
      foreground = named.white;
      palette = colors.indexed |> lib.lists.imap0 (i: v: "${builtins.toString i} = ${v}");
      cursor-color = named.white;
      split-divider-color = named.bright_black;
      cursor-style-blink = false;
      cursor-style = "block";
      mouse-hide-while-typing = true;
      shell-integration-features = "no-cursor";
      selection-foreground = "cell-background";
      selection-background = "cell-foreground";
      # TODO enable after updating
      # search-foreground = named.black;
      # search-background = named.dark_yellow;
      # search-selected-foreground = named.black;
      # search-selected-background = named.yellow;
      bell-features = "no-title no-attention";
      font-size = 16;
      window-decoration = "none";
      window-show-tab-bar = "never";
      keybind =
        {
          "super+t" = "new_tab";
          "super+s" = "toggle_tab_overview";
          "super+c" = "copy_to_clipboard";
          "super+v" = "paste_from_clipboard";
          "alt+asterisk" = "toggle_split_zoom";
          "alt+arrow_right" = "goto_split:right";
          "alt+arrow_left" = "goto_split:left";
          "alt+arrow_down" = "goto_split:down";
          "alt+arrow_up" = "goto_split:up";
          "alt+shift+arrow_right" = "new_split:right";
          "alt+shift+arrow_left" = "new_split:left";
          "alt+shift+arrow_down" = "new_split:down";
          "alt+shift+arrow_up" = "new_split:up";
          "ctrl+shift+x" = "write_scrollback_file:open";
        }
        |> lib.attrsets.attrsToList
        |> builtins.map (kv: "${kv.name}=${kv.value}");
    };
    # systemd.enable = true;
  };
}
