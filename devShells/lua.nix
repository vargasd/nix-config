pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    lua-language-server
    stylua
  ];
}
