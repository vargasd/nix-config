{
  ...
}:
{
  programs.bash = {
    enable = true;
    enableVteIntegration = true;

    historyControl = [
      "ignoredups"
      "ignorespace"
    ];

    sessionVariables = {
      RED = "\\[\\e[31m\\]";
      GREEN = "\\[\\e[32m\\]";
      YELLOW = "\\[\\e[33m\\]";
      BLUE = "\\[\\e[34m\\]";
      MAGENTA = "\\[\\e[35m\\]";
      CYAN = "\\[\\e[36m\\]";
      BOLD = "\\[\\e[1m\\]";
      RESET = "\\[\\e[0m\\]";
    };

    profileExtra = /* bash */ ''
      export PROMPT_COMMAND='
        _EXIT=$?;
        _EXIT_COLOR="$(test $_EXIT -eq 0 && echo "''${BOLD}''${GREEN}" || echo "''${BOLD}''${RED}")";
        _ZMX="''${ZMX_SESSION:+ ''${MAGENTA}$ZMX_SESSION}";
        _GIT_REF="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)";
        _GIT="''${_GIT_REF:+ ''${CYAN}$_GIT_REF}";
        PS1="\n''${_EXIT_COLOR}\w''${_ZMX}''${_GIT}\n''${YELLOW}$ ''${RESET}"
      '
    '';

  };
}
