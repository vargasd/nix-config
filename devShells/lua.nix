{
  pkgs,
  vimPkgs,
  ...
}:
{
  packages = with pkgs; [
    emmylua-ls
    stylua
  ];

  lspConfig = {
    emmylua_ls = { };

    efm.settings.languages.lua = [
      {
        formatCanRange = true;
        formatCommand = "stylua --color Never \${--range-start:charStart} \${--range-end:charEnd} --stdin-filepath '\${INPUT}' -";
        formatStdin = true;
        rootMarkers = [
          "stylua.toml"
          ".stylua.toml"
        ];
      }
    ];
  };

  shellHook =
    let
      luarc = pkgs.mk-luarc-json { plugins = (vimPkgs pkgs); };
    in
    /* bash */ ''
      ln -fs ${luarc} .luarc.json
    '';
}
