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
in
{
  all =
    emojiData
    ++
      # TODO use https://unicode.org/Public/16.0.0/ucd/UnicodeData.txt or something else for symbols
      [ ]
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
