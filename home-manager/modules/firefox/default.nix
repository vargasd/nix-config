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
    customAddons.duplicate-tab-closer
  ];
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
      # "browser.startup.homepage" = "about:blank";
      "browser.newtabpage.enabled" = true;
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
      "reader.custom_colors.background" = "#${background}";
      "reader.custom_colors.foreground" = "#${white}";
      "reader.custom_colors.selection-highlight" = "#${yellow}";
      "reader.custom_colors.unvisited-links" = "#${blue}";
      "reader.custom_colors.visited-links" = "#${magenta}";
      # "layout.css.prefers-color-scheme.content-override" = 1; # light mode (let dark reader take over)
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

            # close tabs in tab view
            mapKey <c-x:o> <s-delete> 
          '';
          searchUrl = "https://www.google.com/search?q=$s Google";
          showAdvancedCommands = false;
        };
      };

      settings.${customAddons.duplicate-tab-closer.addonId} = {
        force = true;
        settings = {
          caseInsensitive.value = true;
          ignore3w.value = true;
          ignoreHashPart.value = true;
          ignorePathPart.value = false;
          ignoreSearchPart.value = false;
          keepPinnedTab.value = true;
          keepTabWithHttps.value = true;
          onDuplicateTabDetected.value = "A";
          onRemainingTab.value = "A";
          scope.value = "CC";
          blackList.value = [ ] |> lib.strings.concatLines;
          whiteList.value =
            [
              "https://kibana.service.emarsys.net/*"
            ]
            |> lib.strings.concatLines;
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
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    profiles.default = config;
    setAsDefaultBrowser = true;
  };

  programs.firefox = {
    enable = true;
    profiles.default = config;
  };
}
