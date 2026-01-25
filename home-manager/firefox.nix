{
  inputs,
  pkgs,
  lib,
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
in
{

  enable = true;
  profiles.default =
    let
      ext = inputs.firefox-addons.packages.${pkgs.system};
      navbar = [
        "back-button"
        "forward-button"
        "urlbar-container"
        "unified-extensions-button"
      ];
      exts = [
        ext.vimium-c
        ext.ublock-origin
        ext.multi-account-containers
        ext.browserpass
        customAddons.tabDeduplicator
      ];
    in
    {
      containersForce = true;
      containers = {
        primary = {
          color = "blue";
          icon = "fingerprint";
          id = 1;
        };
        alt = {
          color = "orange";
          icon = "fingerprint";
          id = 2;
        };
      };
      isDefault = true;
      # https://support.mozilla.org/en-US/questions/1372399
      userChrome = /*css*/ ''
        .browserContainer > findbar {
          order: -1 !important; /* for 113 and newer */
          border-top: none !important;
          border-bottom: 1px solid ThreeDShadow !important;
          transition: none !important;
        }
      '';
      settings = {
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

        # disable bad suggestions
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.quicksuggest.all" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.topsites" = false;

        # disable animations
        "toolkit.cosmeticAnimations.enabled" = false;
        "toolkit.scrollbox.smoothScroll" = false;

        # disable AI tab groups
        "browser.tabs.groups.smart.userEnabled" = false;

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
              value = "";
            };
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
}
