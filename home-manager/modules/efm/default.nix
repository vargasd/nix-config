{ lib, ... }:
let
  prettier = {
    format-can-range = true;
    format-command = "prettierd '\${INPUT}' \${--range-start=charStart} \${--range-end=charEnd} --config-precedence=prefer-file";
    format-stdin = true;
    root-markers = [
      ".prettierrc"
      ".prettierrc.json"
      ".prettierrc.js"
      ".prettierrc.yml"
      ".prettierrc.yaml"
      ".prettierrc.json5"
      ".prettierrc.mjs"
      ".prettierrc.cjs"
      ".prettierrc.toml"
      "prettier.config.js"
      "prettier.config.cjs"
      "prettier.config.mjs"
    ];
  };

  biome = {
    format-command = "biome check --write --stdin-file-path '\${INPUT}'";
    format-stdin = true;
    root-markers = [ "biome.json" ];
    require-marker = true;
  };

  config = {
    languages = {
      javascript = [
        prettier
        biome
      ];
      javascriptreact = [
        prettier
        biome
      ];
      typescript = [
        prettier
        biome
      ];
      typescriptreact = [
        prettier
        biome
      ];
      vue = [
        prettier
        biome
      ];
      svelte = [
        prettier
        biome
      ];
      json = [
        prettier
        biome
      ];
      jsonc = [
        prettier
        biome
      ];
      css = [
        prettier
        biome
      ];
      html = [
        prettier
        biome
      ];
      markdown = [ prettier ];
      typespec = [ prettier ];
      yaml = [ prettier ];
      sql = [
        {
          format-command = "sqruff fix -";
          format-stdin = true;
          root-markers = [ ".sqruff" ];
        }
      ];
      python = [
        {
          format-command = "ruff format --no-cache -";
          format-stdin = true;
          root-markers = [
            "pyproject.toml"
            "ruff.toml"
            ".ruff.toml"
          ];
        }
      ];
      nix = [
        {
          format-command = "nixfmt";
          format-stdin = true;
          root-markers = [
            "flake.nix"
            "shell.nix"
            "default.nix"
          ];
        }
      ];
      lua = [
        {
          format-can-range = true;
          format-command = "stylua --color Never \${--range-start:charStart} \${--range-end:charEnd} --stdin-filepath '\${INPUT}' -";
          format-stdin = true;
          root-markers = [
            "stylua.toml"
            ".stylua.toml"
          ];
        }
      ];
      kotlin = [
        {
          prefix = "ktlint";
          lint-source = "ktlint";
          lint-command = "--no-color --stdin-filename '\${INPUT}' --stdin";
          lint-stdin = true;
          lint-formats = [
            "%\\s%#%l:%c %# %trror  %m"
            "%\\s%#%l:%c %# %tarning  %m"
          ];
          lint-ignore-exit-code = true;
          format-command = "ktfmt -";
          format-stdin = true;
        }
      ];
      gleam = [
        {
          format-command = "gleam format --stdin";
          format-stdin = true;
        }
      ];
      zig = [
        {
          format-command = "zig fmt --stdin";
          format-stdin = true;
        }
      ];
      terraform = [
        {
          format-command = "terraform fmt -";
          format-stdin = true;
        }
      ];
    };
  };
in
{
  xdg.configFile."efm-langserver/config.yaml" = {
    enable = true;
    text = lib.generators.toYAML { } config;
  };
}
