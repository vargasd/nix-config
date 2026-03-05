{ pkgs, ... }:
let
  efm_config = {
    formatCommand = "biome check --write --stdin-file-path '\${INPUT}'";
    formatStdIn = true;
    rootMarkers = [
      "biome.json"
      "package.json"
    ];
  };
in
{
  packages = with pkgs; [ biome ];

  lspConfig = {
    biome = { };
    efm.settings.languages = {
      html = [ efm_config ];
      javascript = [ efm_config ];
      json = [ efm_config ];
      jsonc = [ efm_config ];
      typescript = [ efm_config ];
    };
  };
}
