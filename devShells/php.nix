{ pkgs, ... }:
{
  packages = with pkgs; [
    phpactor
    php
  ];

  lspConfig = {
    phpactor = { };
  };
}
