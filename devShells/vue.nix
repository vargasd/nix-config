pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    vue-language-server
  ];
  SAM_LSP_CONFIGS = builtins.toJSON {
    vue_ls = { };
    ts_ls = {
      init_options = {
        plugins = [
          {
            name = "@vue/typescript-plugin";
            location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
            languages = [ "vue" ];
            configNamespace = "typescript";
          }
        ];
      };
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
