{ ... }:
{
  # for fish completions
  programs.fish.enable = true;
  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
      render_right_prompt_on_last_line = false;
      table.mode = "single";
      color_config = {
        shape_internalcall = "default";
        shape_external = "default";
        shape_externalarg = "default";
        shape_filepath = "blue";
        shape_directory = "blue";
        shape_globpattern = "magenta";
        shape_operator = "white";
        shape_flag = "yellow";
      };
    };
    environmentVariables = {
      PROMPT_COMMAND_RIGHT = "";
      PROMPT_INDICATOR = "";
      PROMPT_INDICATOR_VI_INSERT = "";
      PROMPT_INDICATOR_VI_NORMAL = "";
      PROMPT_MULTILINE_INDICATOR = "∙ ";
    };
    extraConfig = builtins.readFile ./config.nu;
  };
}
