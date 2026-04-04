{ pkgs, ... }:
with pkgs.vimPlugins;
(
  # lazy
  [
    mini-surround
    vim-sleuth
    flash-nvim
    nvim-next
    vim-fugitive
    gitsigns-nvim
    blink-cmp
    nvim-dap
    nvim-dap-virtual-text
    vim-dadbod
    vim-dadbod-completion
    vim-dadbod-ui
    which-key-nvim
    yazi-nvim
    nvim-treesitter-textobjects
    lualine-nvim
    noice-nvim
    nui-nvim
    render-markdown-nvim
    rainbow_csv
    nvim-lspconfig
    snacks-nvim
    nvim-treesitter.withAllGrammars # sure why not
  ]
  |> map (plugin: {
    plugin = plugin;
    optional = true;
  })
)
# eager
++ [
  lze
  enhansi-nvim
]
