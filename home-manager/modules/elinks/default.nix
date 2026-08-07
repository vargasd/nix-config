{ pkgs, lib, ... }:
let
  # https://discourse.nixos.org/t/flatten-nested-set-to-name-value-pairs-named-after-the-old-path/59713
  flatten = (
    set:
    let
      recurse =
        path:
        lib.concatMapAttrs (
          name: value:
          if builtins.isAttrs value then
            recurse (path ++ [ name ]) value
          else
            { ${builtins.concatStringsSep "." (path ++ [ name ])} = value; }
        );
    in
    recurse [ ] set
  );
  stringify = val: if builtins.isString val then ''"${val}"'' else toString val;
in
{
  home.packages = [ pkgs.elinks ];
  xdg.configFile."elinks/elinks.conf" = {
    enable = true;
    text =
      {
        terminal =
          [
            "xterm-256color"
            "xterm-ghostty"
            "foot"
          ]
          |> map (term: {
            name = term;
            value = {
              strike = 1;
              italic = 1;
              underline = 1;
              utf_8_io = 1;
              type = 1; # box-drawing border
              colors = 1; # 16 colors
            };
          })
          |> builtins.listToAttrs;

        document.html.compress_empty_lines = 1;
        document.plain.display_links = 1;

        # mime = {
        #   mailcap.enable = 0;
        #   handler.chafa.unix = {
        #     ask = 0;
        #     block = 1;
        #     program = "${lib.getExe pkgs.chafa} %f && read -n 1 -p \\'Press any key to continue\\'";
        #   };
        #
        #   extension.jpg = "image/jpeg";
        #   extension.jpeg = "image/jpeg";
        #   extension.png = "image/png";
        #   extension.gif = "image/gif";
        #   extension.webp = "image/webp";
        #   extension.bmp = "image/bmp";
        #
        #   type.image.png = "chafa";
        #   type.image.jpeg = "chafa";
        #   type.image.jpg = "chafa";
        #   type.image.gif = "chafa";
        # };

        ui = {
          clock.enable = 0;
          date_format = "%s";
          dialogs = {
            underline_hotkeys = 1;
            underline_button_shortcuts = 1;
            listbox_min_height = 20;
          };
          clipboard = {
            remove_leading_spaces = 1;
            remove_trailing_spaces = 1;
          };
          show_title_bar = 0;
          tabs = {
            show_bar = 2;
            top = 1;
          };
          colors.color = {
            dialog = {
              generic = {
                text = "white";
                background = "black";
              };
              frame = {
                text = "darkgray";
                background = "black";
              };
              title = {
                text = "green";
                background = "black";
              };
              text = {
                text = "white";
                background = "black";
              };
              field-text = {
                text = "black";
                background = "white";
              };
              field = {
                text = "black";
                background = "white";
              };
              checkbox = {
                text = "black";
                background = "white";
              };
              button = {
                text = "black";
                background = "white";
              };
              checkbox-selected = {
                text = "white";
                background = "green";
              };
              checkbox-label = {
                text = "white";
                background = "black";
              };
              button-shortcut = {
                text = "red";
                background = "white";
              };
              button-selected = {
                text = "black";
                background = "green";
              };
              button-shortcut-selected = {
                text = "red";
                background = "green";
              };
              meter = {
                text = "white";
                background = "black";
              };
            };
            desktop = {
              text = "white";
              background = "black";
            };
            searched = {
              text = "black";
              background = "yellow";
            };
            clipboard = {
              text = "white";
              background = "fuchsia";
            };
            tabs = {
              unvisited = {
                background = "black";
                text = "white";
              };
              normal = {
                background = "black";
                text = "white";
              };
              loading = {
                background = "black";
                text = "white";
              };
              selected = {
                text = "black";
                background = "white";
              };
              separator = {
                text = "white";
                background = "black";
              };
            };
          };
        };

      }
      |> flatten
      |> lib.mapAttrsToList (name: val: "set ${name} = ${stringify val}")
      |> builtins.concatStringsSep "\n";
  };
}
