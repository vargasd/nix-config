{ pkgs, ... }:
{
  packages = with pkgs; [
    clang
    clang-tools
  ];

  lspConfig = {
    clangd = { };
  };
}
