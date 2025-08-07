pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    vue-language-server
  ];
  SAM_LSP_CONFIGS = builtins.toJSON {
    ts_ls.autostart = false;
    vue_ls = { };
    vtsls = {
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = [
              {
                name = "@vue/typescript-plugin";
                location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
                languages = [ "vue" ];
                configNamespace = "typescript";
              }
            ];
          };
        };
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
