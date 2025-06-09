pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    nixd
    nixfmt-rfc-style
  ];
  shellHook = ''
    cat <<- LUA > .lazy.lua
      vim.lsp.enable("nixd")
      return {}
    LUA
  '';
}
