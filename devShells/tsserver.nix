{ pkgs, ... }:
{
  packages = with pkgs; [ typescript-language-server ];

  lspConfigs = {
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
