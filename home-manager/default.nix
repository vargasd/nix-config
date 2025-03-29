user:
{ pkgs, inputs, ... }:
{
  home.stateVersion = "25.05";

  home.username = user;
  home.homeDirectory = "/Users/${user}";

  programs.home-manager.enable = true;

  programs.bat = {
    enable = true;
    config = {
      theme = "enhansi";
      style = "plain";
    };
    syntaxes = {
      typespec = {
        src = pkgs.fetchFromGitHub {
          owner = "vargasd";
          repo = "langthing";
          rev = "581e54ee64b46ace0fbd23e221ade8088f491d4e";
          hash = "sha256-/RLHHnCS4fMHPsSTRV/kLm7IUD2To3Hlk9vfiQG0UOs=";
        };
        file = "typespec/syntax/typespec.sublime-syntax";
      };
    };
    themes = {
      enhansi = {
        src = pkgs.fetchFromGitHub {
          owner = "vargasd";
          repo = "enhansi";
          rev = "7f28b3d4d4364309d8f098d99ba0d75e51bd3f2f";
          hash = "sha256-kU642R/ugvSWpi99WR2OYfN3RT+Li0fe0HraCT9BP6M=";
        };
        file = "enhansi.tmTheme";
      };
    };
    extraPackages = [ pkgs.bat-extras.batman ];
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

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.firefox = {
    enable = true;
    profiles.default =
      let
        ext = inputs.firefox-addons.packages.${pkgs.system};
      in
      {
        bookmarks = [ ];
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "about:blank";
          "browser.search.isUS" = true;
          "browser.toolbarbuttons.introduced.sidebar-button" = true;
          "browser.aboutConfig.showWarning" = false;
          "browser.urlbar.suggest.searches" = false;

          # UI stuff; not sure how much is actually needed
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "browser.uiCustomization.horizontalTabstrip" = [
            "tabbrowser-tabs"
            "new-tab-button"
          ];
          "browser.uiCustomization.navBarWhenVerticalTabs" = [
            "sidebar-button"
            "back-button"
            "forward-button"
            "urlbar-container"
            "unified-extensions-button"
          ];
          "browser.uiCustomization.state" = {
            "placements" = {
              "widget-overflow-fixed-list" = [ ];
              "unified-extensions-area" = [
                "vimium-c_gdh1995_cn-browser-action"
                "ublock0_raymondhill_net-browser-action"
              ];
              "nav-bar" = [
                "sidebar-button"
                "back-button"
                "forward-button"
                "urlbar-container"
                "unified-extensions-button"
              ];
              "TabsToolbar" = [ ];
              "vertical-tabs" = [ "tabbrowser-tabs" ];
              "PersonalToolbar" = [ "personal-bookmarks" ];
            };
            "currentVersion" = 21;
            "newElementCount" = 2;
          };
        };
        extensions = with ext; {
          force = true;
          packages = [
            vimium-c
            ublock-origin
          ];
          settings.${ext.vimium-c.addonId} = {
            force = true;
            settings = {
              newTabUrl_f = "about:newtab";
              vimSync = true;
              keyLayout = 2;
              exclusionRules = [ ];
              linkHintCharacters = "trasneiogm";
              searchEngines = ''
                g: https://www.google.com/search?q=%s
                www.google.com re=/^(?:\.[a-z]{2,4})?\\/search\\b.*?[#&?]q=([^#&]*)/i
                blank=https://www.google.com/ Google'';
              regexFindMode = true;
              # innerCSS = "1.99.997,136a;:host{display:contents!important}:host:before,:host:after{display:none!important}.R{all:initial;color:#000;contain:layout style;direction:ltr;font:12px/1 \"Helvetica Neue\",Arial,sans-serif;pointer-events:none;position:fixed;user-select:none;z-index:2147483647}.HM{font-weight:bold;position:absolute;white-space:nowrap}.DLG::backdrop{background:#0000}.LH{box-sizing:border-box;background:linear-gradient(#fff785,#ffc542);border:0.01px solid #e3be23;border-radius:3px;box-shadow:0 3px 5px #0000004d;box-sizing:border-box;contain:layout style;overflow:hidden;padding:2.5px 3px 2px;position:absolute}.IH{background:#fff7854d;border:0.01px solid #c38a22;position:absolute}.IHS{background:#f664;border-color:#933}.HUD,.TEE{bottom:-1px;font-size:14px;height:20px;line-height:16px;max-width:336px;min-width:152px;overflow:hidden;padding:4px 4px 1px;right:152px;text-overflow:ellipsis;white-space:nowrap}.HUD:after{background:#eee;border-radius:4px 4px 0 0;border:0.01px solid #bbb;content:\"\";position:absolute;z-index:-1}.HL{max-width:60vw;right:-4px;padding-right:8px}.HUD.UI{cursor:text;height:24px}.Find{cursor:text;position:static;width:100%}.Flash{box-shadow:0 0 4px 2px #4183c4;padding:1px}.AbsF{padding:0;position:absolute}.Sel{box-shadow:0 0 4px 2px #fa0}.Frame{border:5px solid #ff0}.Frame,.DLG,.HUD:after{box-sizing:border-box;height:100%;left:0;top:0;width:100%}.Omnibar{left:calc(10vw - 12px);height:520px;top:64px;width:calc(80vw + 24px)}.O2{left:calc(10% - 12px);width:calc(80% + 24px)}.BH{color:#902809}.MC,.MH{color:#d4ac3a}.One{border-color:#fa7}.UI,.DLG{color-scheme:light;pointer-events:all}.PO{all:initial;left:0;position:absolute;top:0}.D>.LH{background:linear-gradient(#cb0,#c80)}.HUD.D{color:#ccc}.HUD.D:after{background:#222}@media(forced-colors:active){.R{border-radius:0}.HM>.LH,.HUD:after{background:#000;border-radius:0}.Flash{outline:4px solid #fff}}.DLG>.Omnibar{position:absolute}\n.LH {\n  font-size: 15px;\n  opacity: 0.7;\n}\n\n.HUD {\n  top: -1px;\n  bottom: auto;\n  left: 50%;\n  right: auto;\n  padding: 0 4px 5px 4px;\n  border-radius: 0 0 4px 4px;\n  transform: translateX(-50%);\n}";
              # findCSS = "737\n::selection { background: #ff9632 !important; }\nhtml, body, * { user-select: auto; }\n*{cursor:text;font:14px/16px \"Helvetica Neue\",Arial,sans-serif;margin:0;outline:none;white-space:pre}\n.r{all:initial;background:#fff;border-radius:3px 3px 0 0;box-shadow:inset 0 0 1.5px 1px #aaa;color:#000;\ncursor:text;display:flex;height:21px;padding:4px 4px 0}.r.D{background:#222;color:#d4d4d4}\n#s{flex:0 0 4px}#i{flex:0 1 auto;height:16px;min-width:9px;margin-left:2px;overflow:hidden;padding:0 2px 0 0}\n#h{flex:1 0 auto}br{all:inherit!important;display:inline!important}#c{flex:0 0 auto;margin-left:2px}\n#s::after{content:\"/\"}#c::after{content:attr(data-vimium);display:inline}\n:host,body{background:#0000!important;margin:0!important;height:24px}";
              userDefinedCss = ''
                 /* #ui */
                .LH {
                   font-size: 15px;
                   opacity: 0.7;
                 }

                 .HUD {
                   top: -1px;
                   bottom: auto;
                   left: 50%;
                   right: auto;
                   padding: 0 4px 5px 4px;
                   border-radius: 0 0 4px 4px;
                   transform: translateX(-50%);
                 }
              '';
              keyMappings = ''
                #!no-check
                mapKey U X
                mapKey t T
                mapKey J K
                mapKey K J
                unmap p
                unmap m
                unmap /
              '';
              searchUrl = "https://www.google.com/search?q=$s Google";
              showAdvancedCommands = false;
            };
          };
        };
        search = {
          force = true;
          default = "Kagi";
          engines = {
            "Kagi" = {
              urls = [
                {
                  template = "https://kagi.com/search?";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
          };
        };
      };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--color=16" ];
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.git = import ./git.nix;

  programs.lazygit = {
    enable = true;
    settings = {
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
      };
    };
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    initLua = # lua
      ''
        th.git = th.git or {}
        th.git.modified = ui.Style():fg("blue")
        th.git.deleted = ui.Style():fg("red")
        th.git.added = ui.Style():fg("green")
        th.git.ignored = ui.Style():fg("darkgray")

        th.git.modified_sign = "M"
        th.git.added_sign = "A"
        th.git.untracked_sign = "U"
        th.git.ignored_sign = "I"
        th.git.deleted_sign = "D"

        require("git"):setup()
      '';

    keymap = {
      manager.prepend_keymap = [
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
      ];
    };

    plugins =
      let
        plugins = pkgs.fetchFromGitHub {
          owner = "yazi-rs";
          repo = "plugins";
          rev = "cb6165b25515b653a70f72a67889579d190facfe";
          hash = "sha256-XDz67eHmVM5NrnQ/uPXN/jRgmrShs80anWnHpVmbPO8=";
        };
      in
      {
        git = plugins + "/git.yazi";
        chmod = plugins + "/chmod.yazi";
        bat = pkgs.fetchFromGitHub {
          owner = "vargasd";
          repo = "bat.yazi";
          rev = "e5f28d52e51450fe0d66e0d4661e6ba7b6d5edd6";
          hash = "sha256-tCOWMQC0Sea3DI0jEu28Qzzyt1l3bSuOlPWIRiHAQ50=";
        };
      };

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_reverse = false;
        sort_dir_first = true;
      };

      plugin.prepend_previewers = [
        {
          name = "*.tsp";
          run = "bat";
        }
      ];

      plugin.prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableVteIntegration = true;

    history = {
      append = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      save = 50000;
      size = 50000;
      share = false;
    };

    initContent = builtins.readFile ./init.zsh;

    initExtra = "source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh";

    shellAliases = {
      jqi = # sh
        ''
          f() { 
            echo "" | fzf -q "." \
            --bind "shift-up:preview-half-page-up,shift-down:preview-half-page-down,load:unbind(enter)" \
            --preview-window "bottom:99%" \
            --print-query \
            --preview "cat $1 | jq ''\${@:2} {q} | bat --color=always --plain -l json" \
          }; f'';
      man = "batman";
      nvim = # sh
        "env TERM=wezterm nvim";
    };

    sessionVariables = {
      LESS = "-i -R --no-init --tabs 2";
      LESSHISTFILE = "-";
    };
  };

  targets.darwin = {
    keybindings = {
      "~b" = "moveWordBackward:";
      "~f" = "moveWordForward:";
      "^a" = "moveToBeginningOfLine:";
      "^e" = "moveToEndOfLine:";
      "~d" = "deleteWordForward:";
      "^w" = "deleteWordBackward:";
      "^u" = "deleteToBeginningOfLine:";
    };
  };

  xdg = {
    enable = true;
    configFile.nvim = {
      enable = true;
      source = ./nvim;
    };
  };

  home.file = {
    "Library/Application Support/ueli/ueli9.settings.json".text = builtins.toJSON {
      "extensions.enabledExtensionIds" = [
        "SystemSettings"
        "ApplicationSearch"
        "UeliCommand"
      ];
      "general.hotkey" = "Cmd+Space";
    };
  };
}
