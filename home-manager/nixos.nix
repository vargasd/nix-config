{
  pkgs,
  lib,
  inputs,
  home,
  ...
}:
{
  /*
    TODO
      - clipboard (cliphist?)
      - auto dark mode (darkman?)
      - screencast/share (https://github.com/niri-wm/niri/wiki/Important-Software#portals)
  */

  imports = [
    ./default.nix
    ./modules/foot
    ./modules/fuzzel
    ./modules/keyd
    ./modules/mako
    ./modules/niri
    ./modules/swayidle
    ./modules/swaylock
    ./modules/waybar
  ];

  home = {
    sessionVariables = {
      TERMCMD = "${pkgs.foot}/bin/footclient";
      TERMINAL = "${pkgs.foot}/bin/footclient";
    };
    packages = with pkgs; [
      bluetui
      brightnessctl
      impala
      libnotify
      neovim-remote
      bemoji
      # needed to insert for bemoji
      wtype
    ];
  };

  services.gpg-agent.pinentry =
    let
      program = "pinentry-fuzzel";
    in
    {
      package = pkgs.writeShellScriptBin program (
        lib.strings.readFile "${inputs.pinentry-fuzzel}/pinentry-fuzzel"
      );
      program = program;
    };

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  xdg = {
    autostart.enable = true;
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "foot.desktop" ];
      };
    };
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-termfilechooser
      ];
      config.niri = {
        "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
      };
    };

    configFile."xdg-desktop-portal-termfilechooser/config" = {
      enable = true;
      text = ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      '';
    };

    configFile."Yubico/u2f_keys" = {
      enable = true;
      text =
        [
          home.user
          # nix-shell -p pam_u2f --command "pamu2fcfg --type=EDDSA --origin=pam://sam --appid=pam://sam --pin-verification --nouser | cut -d: -f2"
          "2zmrxcXGd8PCp0r5vtGKU4RbDSxvNGH2sRoCjH5c+SaJhyjNkKzosYtOGiPuE97sKvHyB+7QUvPtloT10S7rPd+ee3ftiG6Mb5YOrYzqFFU1SdzfNPx6vLqQRe/dxNzJOdgPmbR+EP6mugeRpYQsK/ZlnvrAe8EHcye1aeln2P4=,c2J3te4nkqT1rR44HdVbszsH2oeggH/wrSBFLGh8qSc=,eddsa,+presence+pin" # 33160604
          "Nafc+KcyWrEePS27MfdQznknD9ZXzGES/n/SXR+g9k1PXiHHKan83b0GmB+rgBjSU0otDLQ4UotM5kNaDOkieBxVXPnP3BgtBONfFjOITGX4nfth43zcNCaO8JkxaCWtEGIYc4mWKOYJhrLd1RTRDyGXFRrMhlel8nY8PnzsEvc=,TMXh5r/Hed8t7gFyesbc9zgIUkqOtaQhj1SS2VnmjOk=,eddsa,+presence+pin" # 27249233
          "R0TKtJa8BJg9ThWHeXuPzQ16SVDZZ5wFeeEYsMYsUXnL1dGpy2RTgI7C+QKRQS+tCmNR7t5B/ZNiiLLD/F3bEzljkPK+N0LdS0SE4tN8SvZLYU/hVCRUfGDTC9jwEYxXDZmM/dPDq82e1pZkIaxPqVxfUeWzzubcwxQRSA3FO34=,eYSAIGCKXKwl7HsTlKFo1x/2B2u07fBGEX9gdIkvZTQ=,eddsa,+presence+pin" # 33983772
          "vev7YghAlk7P0dzI66VSxAa7JP23G6Um6FTXFF7gVfqN+FlUy1ttb7u3X53siJkSdO7HJaM/LkUCqNTJ/uBhG618nCtqN7ZszPc5/BpkdBFLCqca4EJ8Z1diIRCB076bdH0dlJJiFh1eI3asQmgvGT31ON5/YyCZyTVntqysEJg=,MmdHdNDu6KOqp4DLM85I9A4Dcb6qNOQpDiNZbws3T4g=,eddsa,+presence+pin" # 33391299
        ]
        |> builtins.concatStringsSep ":";
    };

    dataFile."bemoji/data.txt" = {
      enable = true;
      text =
        (import ../utils/symbols.nix { inherit pkgs; }).all
        |> builtins.map (data: "${data.emoji} ${data.label}")
        |> builtins.concatStringsSep "\n";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "nvim.desktop";
        "text/markdown" = "nvim.desktop";
        "application/json" = "nvim.desktop";
        "application/schema+json" = "nvim.desktop";
        "text/css" = "nvim.desktop";
      };
    };

    desktopEntries =
      let
        disable = {
          name = "";
          noDisplay = true;
        };
      in
      {
        foot-server = disable;
        vim = disable;
        gvim = disable;
        nvim = {
          name = "Neovim";
          icon = ../assets/neovim.svg;
          exec = "${
            pkgs.writeShellScript "nvim-open" /* sh */ ''
              # wlrctl errors but we need it because we don't have NIRI_SOCKET and it's too annoying to find
              ${lib.getExe pkgs.wlrctl} toplevel focus app_id:foot.neovim >/dev/null 2>/dev/null
              if test $? -ne 134 -a $? -ne 0; then
                footclient --no-wait --app-id foot.neovim zmx attach neovim nvim --listen /tmp/nvimsocket
              fi
              if test -n "$1"; then
                nvr --servername /tmp/nvimsocket $@
              fi
            ''
          } %F";
        };
      };
  };
}
