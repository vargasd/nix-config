{ vimPkgs, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = (vimPkgs pkgs);
  };

  xdg.configFile.nvim = {
    enable = true;
    source = ./config;
  };
}
