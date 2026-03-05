{ pkgs, ... }:
{
  packages = with pkgs; [
    ruby
    bundler
  ];

  lspConfig = { };
}
