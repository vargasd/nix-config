{ pkgs, ... }:
{
  packages = with pkgs; [ pnpm ];

  lspConfig = { };
}
