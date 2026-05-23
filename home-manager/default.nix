{ pkgs, ... }:
{
  imports = [
    ./modules/bat
    ./modules/firefox
    ./modules/git
    ./modules/gpg
    ./modules/neovim
    ./modules/yazi
    ./modules/zsh
  ];

  home.stateVersion = "26.05";

  home.sessionVariables = {
    LESS = "-i -R --no-init --tabs 2";
    LESSHISTFILE = "-";
    MANPAGER = "nvim +Man!";
    HUSKY = 0;
    EDITOR = "nvim";
    VISUAL = "nvim";
    TZ = "America/Indiana/Indianapolis";
    MOZ_DISABLE_SAFE_MODE_KEY = 1;
  };

  home.packages = with pkgs; [
    docker
    fd
    # go-task # Taskfile support
    hurl
    # imagemagick
    jless
    jq
    # lazydocker
    mermaid-cli
    # neofetch
    nodejs
    pass
    postgresql
    # presenterm
    ripgrep
    sqlite
    up # https://github.com/akavel/up
    yubikey-manager

    # language servers
    bash-language-server
    vscode-langservers-extracted # css, eslint, html, json
    efm-langserver
    harper
    marksman
    postgres-language-server
    typescript-language-server
    # typos-lsp
    yaml-language-server

    # formatters
    prettierd
    vscode-js-debug

    # fonts
    jetbrains-mono
    noto-fonts-monochrome-emoji
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
  programs.browserpass.enable = true;
  programs.dircolors.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.eza.enable = true;
  programs.fzf.enable = true;
  programs.fzf.defaultOptions = [ "--color=16" ];
  programs.zoxide.enable = true;

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    # daemon.enable = true;
    settings = {
      update_check = false;
      show_help = false;
      invert = true;
      prefers_reduced_motion = true;
      show_numeric_shortcuts = false;
      logs = {
        enabled = false;
        dir = "~/.local/state/atuin/logs";
      };
      search.filters = [
        "global"
        "workspace"
        "directory"
      ];
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      truecolor = false;
      rounded_corners = false;
      shown_boxes = "proc cpu mem";
      show_disks = false;
      update_ms = 5000;
      proc_tree = true;
      proc_per_core = false;
      log_level = "ERROR";
    };
  };

  programs.opencode = {
    enable = true;
    tui.settings = {
      theme = "system";
      share = "disabled";
      keybinds = {
        leader = "tab";
        agent_cycle = "shift+tab";
        messages_half_page_up = "pgup";
        messages_half_page_down = "pgdown";
        messages_page_up = "ctrl+b";
        messages_page_down = "ctrl+f";
        input_newline = "shift+enter,ctrl+j,alt+enter";
      };
      mcp = { };
    };
  };

  home.preferXdgDirectories = true;
  xdg = {
    enable = true;
    configFile."typos-lsp/typos.toml" = {
      enable = true;
      text = # toml
        ''
          [default]
          extend-ignore-words-re = [
            "\\b[Nn]oice\\b"
          ]
        '';
    };
    configFile."presenterm/config.yaml" = {
      enable = true;
      text = builtins.toJSON {
        defaults = {
          theme = "terminal-dark";
        };
        options = {
          command_prefix = ".";
          # end_slide_shorthand = true;
          # implicit_slide_ends = true;
          strict_front_matter_parsing = false;
          auto_render_languages = [ "mermaid" ];
        };
      };
    };
  };
}
