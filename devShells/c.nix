pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    clang
    clang-tools
  ];
  shellHook = ''
    cat <<- LUA > .lazy.lua
      vim.lsp.enable("clangd")
      return {}
    LUA
  '';
}
