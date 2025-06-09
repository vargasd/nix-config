pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    lua-language-server
    stylua
  ];
  shellHook = ''
    cat <<- LUA > .lazy.lua
      vim.lsp.enable("lua_ls")
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            telemetry = { enable = false },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      return {}
    LUA
  '';
}
