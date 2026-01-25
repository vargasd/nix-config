{
  inputs,
  pkgs,
  ...
}:
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
      settings = {
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
            "unified-extensions-area" = [
              "_testpilot-containers-browser-action" # multi-account-containers
              ext.vimium-c.addonId
              "ublock0_raymondhill_net-browser-action" # dunno why this is different from vimium
            ];
          };
          "currentVersion" = 21; # also needed
        };

        # disable password manager
        "signon.rememberSignons" = false;
      };
      extensions = with ext; {
        force = true;
        packages = [
          vimium-c
          ublock-origin
          multi-account-containers
          browserpass
          # pwas-for-firefox
        ];
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
