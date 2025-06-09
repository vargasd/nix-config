pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    phpactor
    php
  ];
  shellHook = ''
    cat <<- LUA > .lazy.lua
      vim.lsp.enable("phpactor")
      return {}
    LUA
  '';
}
