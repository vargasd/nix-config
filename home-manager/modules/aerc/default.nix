{
  pkgs,
  lib,
  ...
}:
{
  programs.aerc = {
    enable = true;
    extraConfig = {
      general = {
        unsafe-accounts-conf = true;
      };
      viewer = {
        pager = ''nvim --cmd ':lua vim.g.no_plugins=true' -c ":call nvim_open_term(0, {})"'';
      };
      filters = {
        # these are pretty much from the default config (but ya gotta have em)
        "text/plain" = "colorize";
        "text/calendar" = "calendar";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
        "text/html" = "${lib.getExe pkgs.elinks} | colorize";
        "image/*" = "${lib.getExe pkgs.catimg} -w $(tput cols) -";
      };
      ui = {
        icon-encrypted = "";
        icon-signed = "";
        icon-unknown = "";
        icon-invalid = "";
        icon-attachment = "";
        icon-new = "●";
        icon-old = "●";
        icon-replied = "󱞨";
        icon-forwarded = "󱞬";
        icon-flagged = "󰈻";
        icon-draft = "";
      };
      hooks = {
        mail-received = ''notify-send " [$AERC_ACCOUNT] $AERC_SUBJECT" "from $AERC_FROM_NAME"'';
      };
    };
    extraAccounts =
      let
        passGetter = pkgs.writeShellScript "pass-getter" "pass show $1 | head -1";
      in
      [
        "sam"
        "_"
        "home"
      ]
      |> map (acct: {
        name = acct;
        value = {
          source = "imap://${acct}%40varga.sh@shadow.mxrouting.net:143";
          source-cred-cmd = "${passGetter} mxlogin.com/${acct}";
          outgoing = "smtp://${acct}%40varga.sh@shadow.mxrouting.net:587";
          outgoing-cred-cmd = "${passGetter} mxlogin.com/${acct}";
          default = "INBOX";
          from = "Sam Varga <${acct}@varga.sh>";
          cache-headers = true;
        };
      })
      |> builtins.listToAttrs;
  };
}
