{ pkgs, helpers }:
pkgs.mkShell {
  packages = with pkgs; [
    typescript-language-server
  ];

  SAM_LSP_CONFIGS = helpers.extendJsonEnvVar pkgs "SAM_LSP_CONFIGS" {
    tsgo = {
      autostart = false;
    };
    ts_ls = {
      filetypes = [
        "typescript"
        "javascript"
        "javascriptreact"
        "typescriptreact"
        "vue"
      ];
    };
  };
}
