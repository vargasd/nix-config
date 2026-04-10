{ pkgs, ... }:
{
  packages = with pkgs; [
    go
    gopls
    delve
  ];

  lspConfig = {
    gopls = { };
  };
}
