{ pkgs, ... }:
{
  packages = with pkgs; [
    go
    gopls
  ];

  lspConfig = {
    gopls = { };
  };
}
