{ pkgs, ... }:
{
  packages = with pkgs; [ typescript-go ];

  lspConfigs = {
    tsgo = {
      autostart = false;
      filetypes = [ ];
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
