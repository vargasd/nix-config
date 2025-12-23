{ pkgs, helpers }:
pkgs.mkShell {
  packages = with pkgs; [
    lua-language-server
    stylua
  ];

  SAM_LSP_CONFIGS = helpers.extendJsonEnvVar pkgs "SAM_LSP_CONFIGS" {
    efm.settings.languages.lua = [
      {
        formatCanRange = true;
        formatCommand = "stylua --color Never \${--range-start:charStart} \${--range-end:charEnd} --stdin-filepath '\${INPUT}' -";
        formatStdin = true;
        rootMarkers = [
          "stylua.toml"
          ".stylua.toml"
        ];
      }
    ];
  };
}
