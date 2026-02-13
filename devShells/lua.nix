{ pkgs, helpers }:
pkgs.mkShell {
  packages = with pkgs; [
    emmylua-ls
    stylua
  ];

  SAM_LSP_CONFIGS = helpers.extendJsonEnvVar pkgs "SAM_LSP_CONFIGS" {
    emmylua_ls = { };

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
