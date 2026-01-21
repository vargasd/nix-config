{ pkgs, helpers }:
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
pkgs.mkShell {
  packages = with pkgs; [
    biome
  ];

  SAM_LSP_CONFIGS = helpers.extendJsonEnvVar pkgs "SAM_LSP_CONFIGS" {
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
