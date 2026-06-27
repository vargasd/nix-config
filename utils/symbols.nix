{
  pkgs,
  ...
}:
let
  nerdData =
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/1514941a80397d93361f4193346d9cbb9ed21c6e/glyphnames.json";
      hash = "sha256-4tENI/W/8L1vBnbpsB2XifzcZW3ntJiilVwncW6kQ5w=";
    }
    |> builtins.readFile
    |> builtins.fromJSON;
  emojiData =
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/milesj/emojibase/a5fc630a91ca42cddf3f4a66492965600fd3bce8/packages/data/en/data.raw.json";
      hash = "sha256-uegbJv4qWVEgrHuNRPjB4C4dDM4xE3tVCuD9zrK0CeE=";
    }
    |> builtins.readFile
    |> builtins.fromJSON;
  unicodeData =
    pkgs.fetchurl {
      url = "https://unicode.org/Public/16.0.0/ucd/extracted/DerivedName.txt";
      hash = "sha256-DMFGn6oMVRhXLvk/T0V/k6qKFgzjIKrTeT2F9LQ1/SQ=";
    }
    |> builtins.readFile;
in
{
  all =
    emojiData
    ++ (
      unicodeData
      |> pkgs.lib.splitString "\n"
      |> builtins.filter (line: line != "" && !(pkgs.lib.strings.hasPrefix "#" line))
      |> map (
        line:
        line
        |> pkgs.lib.splitString ";"
        |> (arr: {
          label = builtins.elemAt arr 1 |> pkgs.lib.strings.trim;
          # 🥴 https://discourse.nixos.org/t/how-can-i-put-an-nonprintable-character-in-a-nix-expression/47750/8
          emoji = ''"\u${builtins.elemAt arr 0 |> pkgs.lib.strings.trim}"'' |> builtins.fromJSON;
        })
      )
    )
    ++ (
      builtins.removeAttrs nerdData [ "METADATA" ]
      |> pkgs.lib.mapAttrsToList (
        name: val: {
          label = name;
          emoji = val.char;
        }
      )
    );
}
