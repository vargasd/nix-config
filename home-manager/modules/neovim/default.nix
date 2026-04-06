{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = (import ../../../utils/vim-pkgs.nix pkgs);
  };

  xdg.desktopEntries = {
    vim = {
      name = "vim";
      noDisplay = true;
    };
    gvim = {
      name = "gvim";
      noDisplay = true;
    };
    nvim = {
      name = "nvim";
      noDisplay = true;
    };
  };
  xdg.configFile.nvim = {
    enable = true;
    source = ./config;
  };
}
