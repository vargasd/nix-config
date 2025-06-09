pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    vue-language-server
  ];
  shellHook = ''
    cat <<- LUA > .lazy.lua
      vim.lsp.enable("ts_ls", false)
      vim.lsp.enable("vue_ls")
      vim.lsp.config(
        "vue_ls",
        {
          filetypes = { "typescript", "vue" },
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        }
      )
      return {}
    LUA
  '';
}
