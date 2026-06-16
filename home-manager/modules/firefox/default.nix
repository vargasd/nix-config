{
  inputs,
  pkgs,
  lib,
  colors,
  ...
}:
let
  customAddons = pkgs.callPackage ./addons.nix {
    inherit lib;
    inherit (inputs.firefox-addons.lib.${pkgs.system}) buildFirefoxXpiAddon;
  };
  toMenu =
    addonId:
    lib.strings.replaceStrings [ "@" "." ] [ "_" "_" ] "${addonId}-browser-action" |> lib.toLower;
  ext = inputs.firefox-addons.packages.${pkgs.system};
  navbar = [
    "back-button"
    "forward-button"
    "stop-reload-button"
    "urlbar-container"
    "unified-extensions-button"
  ];
  exts = [
    ext.vimium-c
    ext.ublock-origin
    ext.browserpass
    ext.firefox-color
    ext.darkreader
    customAddons.tabDeduplicator
  ];
  hexToDecMap = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
  };
  toHex = n: hexToDecMap."${n}";
  profile = "default";
  config = {
    isDefault = true;
    # https://support.mozilla.org/en-US/questions/1372399
    userChrome = /* css */ ''
      .browserContainer > findbar {
        order: -1 !important; /* for 113 and newer */
        border-top: none !important;
        border-bottom: 1px solid ThreeDShadow !important;
        transition: none !important;
      }
    '';
    settings = with colors.named; {
      # librewolf
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
      # "privacy.resistFingerprinting.letterboxing" = true;

      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      # blank pages for things
      "browser.startup.homepage" = "about:blank";
      "browser.newtabpage.enabled" = false;
      # restore previous session
      "browser.startup.page" = 3;
      "browser.search.isUS" = true;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.toolbarbuttons.introduced.sidebar-button" = true;
      "browser.aboutConfig.showWarning" = false;

      # always prompt on download
      "browser.download.useDownloadDir" = false;

      # disable bad suggestions
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.suggest.quicksuggest.all" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.suggest.topsites" = false;

      # disable animations
      "toolkit.cosmeticAnimations.enabled" = false;

      # disable AI tab groups
      "browser.tabs.groups.smart.userEnabled" = false;
      "browser.ml.linkPreview.enabled" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

      "ui.key.accelKey" = 91; # super
      # https://kb.mozillazine.org/Ui.key.chromeAccess
      "ui.key.chromeAccess" = 4; # alt
      "ui.key.contentAccess" = 2; # ctrl
      "ui.key.menuAccessKey" = 0; # disable

      "ui.textSelectAttentionBackground" = "#${yellow}";
      "ui.textSelectAttentionForeground" = "#${black}";
      "ui.textHighlightBackground" = "#${magenta}";
      "ui.textHighlightForeground" = "#${black}";

      "reader.color_scheme" = "custom";
      "reader.custom_colors.background" = "#${black}";
      "reader.custom_colors.foreground" = "#${white}";
      "reader.custom_colors.selection-highlight" = "#${yellow}";
      "reader.custom_colors.unvisited-links" = "#${blue}";
      "reader.custom_colors.visited-links" = "#${magenta}";
      "layout.css.prefers-color-scheme.content-override" = 0; # dark mode
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;
      "sidebar.verticalTabs.dragToPinPromo.dismissed" = true; # ftux
      "sidebar.main.tools" = "history"; # need something here to disable the rest...
      "browser.uiCustomization.navBarWhenVerticalTabs" = navbar;
      "browser.uiCustomization.state" = {
        "placements" = {
          "nav-bar" = navbar; # gotta do navbar twice
          "unified-extensions-area" = map (pkg: pkg.addonId |> toMenu) exts;
        };
        "currentVersion" = 21; # also needed
      };

      # disable password manager
      "signon.rememberSignons" = false;

      # needed for yazi picker (?)
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
    extensions = {
      force = true;
      packages = exts;
      settings.${ext.vimium-c.addonId} = {
        force = true;
        settings = {
          newTabUrl_f = "about:newtab";
          vimSync = true;
          keyLayout = 2;
          exclusionRules = [
            {
              passKeys = "t ";
              pattern = ":https://mail.google.com/";
            }
            {

              passKeys = "m ";
              pattern = ":https://meet.google.com/";
            }
            {
              passKeys = "^ f ";
              pattern = ":https://teams.microsoft.com/";
            }
            {
              passKeys = "l t ";
              pattern = ":https://app.slack.com/";
            }
          ];
          linkHintCharacters = "trasneiogm";
          searchEngines = ''
            g: https://www.google.com/search?q=%s
            www.google.com re=/^(?:\.[a-z]{2,4})?\\/search\\b.*?[#&?]q=([^#&]*)/i
            blank=https://www.google.com/ Google'';
          regexFindMode = true;
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
            unmap o
            unmap O
          '';
          searchUrl = "https://www.google.com/search?q=$s Google";
          showAdvancedCommands = false;
        };
      };

      settings.${customAddons.tabDeduplicator.addonId} = {
        force = true;
        settings = {
          blackList = {
            value = "";
          };
          caseInsensitive = {
            value = true;
          };
          ignore3w = {
            value = true;
          };
          ignoreHashPart = {
            value = true;
          };
          ignorePathPart = {
            value = false;
          };
          ignoreSearchPart = {
            value = false;
          };
          keepPinnedTab = {
            value = true;
          };
          keepTabWithHttps = {
            value = true;
          };
          onDuplicateTabDetected = {
            value = "A";
          };
          onRemainingTab = {
            value = "A";
          };
          scope = {
            value = "CC";
          };
          whiteList = {
            value =
              [
                "https://kibana.service.emarsys.net/*"
              ]
              |> lib.strings.concatLines;
          };
        };
      };

      settings.${ext.firefox-color.addonId} = {
        force = true;
        settings =
          with colors.named
          |> builtins.mapAttrs (
            n: val: {
              r = (toHex (builtins.substring 0 1 val)) * 16 + (toHex (builtins.substring 1 1 val));
              g = (toHex (builtins.substring 2 1 val)) * 16 + (toHex (builtins.substring 3 1 val));
              b = (toHex (builtins.substring 4 1 val)) * 16 + (toHex (builtins.substring 5 1 val));
            }
          ); {
            firstRunDone = true;
            theme.colors = {
              frame = black;
              frame_inactive = black;

              toolbar = bright_black;
              toolbar_text = gray;
              toolbar_field = bright_black;
              toolbar_field_text = gray;
              toolbar_field_highlight = dark_blue;
              toolbar_field_border = bright_black;
              toolbar_field_focus = black;
              toolbar_field_border_focus = blue;
              toolbar_field_text_focus = white;
              bookmark_text = gray;

              tab_background_text = gray;
              tab_line = bright_black;
              tab_loading = gray;
              tab_text = gray;

              button_background_active = bright_black;
              button_background_hover = bright_black;

              icons_attention = red;
              icons = gray;

              ntp_background = black;
              ntp_text = gray;

              sidebar = black;
              sidebar_text = gray;
              sidebar_border = bright_black;
              sidebar_highlight = dark_blue;
              sidebar_highlight_text = white;

              popup = black;
              popup_text = gray;
              popup_border = bright_black;
              popup_highlight = dark_blue;
              popup_highlight_text = white;
            };
          };
      };

      settings.${ext.darkreader.addonId} = {
        force = true;
        settings = with colors.named; {
          schemeVersion = 2;
          enabled = true;
          fetchNews = false;
          theme = {
            mode = 1;
            # brightness = 100;
            # contrast = 100;
            # grayscale = 0;
            # sepia = 0;
            useFont = true;
            fontFamily = "JetBrains Mono";
            # textStroke = 0;
            engine = "dynamicTheme";
            # stylesheet = "";
            darkSchemeBackgroundColor = "#${black}";
            darkSchemeTextColor = "#${white}";
            lightSchemeBackgroundColor = "#${white}";
            lightSchemeTextColor = "#${black}";
            # scrollbarColor = "";
            # selectionColor = "";
            styleSystemControls = false;
            lightColorScheme = "Default";
            darkColorScheme = "Default";
            immediateModify = false;
          };
          enabledByDefault = true;
          changeBrowserTheme = false;
          syncSettings = false;
          syncSitesFixes = false;
          automation = {
            behavior = "Scheme";
            enabled = false;
            mode = "";
          };
          time = {
            activation = "18:00";
            deactivation = "9:00";
          };
          location = {
            latitude = null;
            longitude = null;
          };
          previewNewDesign = false;
          previewNewestDesign = false;
          enableForPDF = true;
          enableForProtectedPages = true;
          enableContextMenus = false;
          detectDarkTheme = true;
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
        "DuckDuckGo (No AI)" = {
          urls = [
            {
              template = "https://noai.duckduckgo.com/?";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
        "DuckDuckGo (No JS)" = {
          urls = [
            {
              template = "https://html.duckduckgo.com/html?";
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
in
{
  programs.firefox.profiles.${profile} = config;
  programs.librewolf = {
    enable = true;
    profiles.default = config;
  };

  textfox = {
    enable = true;
    profiles = [ profile ];
    config = with colors.named; {
      background.color = "#${black}";
      border = {
        color = "#${bright_black}";
        width = "2px";
        transition = "none";
        radius = "0";
      };
      navbar = {
        margin = "2px";
        padding = "2px";
      };
      displayWindowControls = false;
      displayNavButtons = true;
      displayUrlbarIcons = false;
      displaySidebarTools = false;
      displayTitles = false;
      font = {
        family = "'JetBrains Mono', monospace";
        size = "15px";
      };
      tabs.vertical.enable = true;
      bookmarks.alignment = "left";
      icons = {
        toolbar.extensions.enable = true;
        context.extensions.enable = true;
        context.firefox.enable = true;
      };
      extraConfig = "/* custom css here */";
    };
  };
}
