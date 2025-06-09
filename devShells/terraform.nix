pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    terraform
    terraform-ls
  ];
  shellHook = ''
    cat <<- LUA > .lazy.lua
      vim.lsp.enable("terraformls")
      return {}
    LUA
  '';
}
