{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = (import ../../../utils/vim-pkgs.nix pkgs);
  };

  xdg.configFile.nvim = {
    enable = true;
    source = ./config;
  };
}
