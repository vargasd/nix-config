{ pkgs, ... }:
{
  imports = [ ./lsp.nix ];

  programs.neovim = {
    enable = true;
    plugins = (import ../../../utils/vim-pkgs.nix pkgs);
  };

  xdg.configFile.nvim = {
    enable = true;
    source = ./config;
  };
}
