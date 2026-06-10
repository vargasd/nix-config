{ pkgs, lib, ... }:
{
  xdg.dataFile."nvim/site/lua/lsp_servers.lua".text = ''
    return ${
      lib.generators.toLua { } {

        bashls = {
          cmd = [
            "${lib.getExe pkgs.bash-language-server}"
            "start"
          ];
          settings.bashIde.shellcheckArguments = [
            "-e"
            "SC2034"
          ];
        };

        harper_ls = {
          cmd = [
            "${lib.getExe pkgs.harper}"
            "--stdio"
          ];
          filetypes = [
            "markdown"
            "asciidoc"
            "tex"
          ];
          settings."harper-ls".linters.SentenceCapitalization = false;
        };

        yamlls = {
          cmd = [
            "${lib.getExe pkgs.yaml-language-server}"
            "--stdio"
          ];
          settings = {
            redhat.telemetry.enabled = false;
            yaml = {
              format.enable = false;
              schemas."https://taskfile.dev/schema.json" = [
                "**/Taskfile.yml"
                "**/Taskfile.yaml"
              ];
            };
          };
        };

        jsonls = {
          cmd = [
            "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server"
            "--stdio"
          ];
          settings.json.schemas = [
            {
              fileMatch = [ "package.json" ];
              url = "https://json.schemastore.org/package.json";
            }
            {
              fileMatch = [
                ".prettierrc"
                ".prettierrc.json"
                "prettier.config.json"
              ];
              url = "https://json.schemastore.org/prettierrc.json";
            }
            {
              fileMatch = [
                ".swcrc"
                ".swcrc.json"
                "swc.config.json"
              ];
              url = "https://swc.rs/schema.json";
            }
            {
              fileMatch = [
                "tsconfig.json"
                "tsconfig.*.json"
                "*.tsconfig.json"
              ];
              url = "http://json.schemastore.org/tsconfig";
            }
          ];
        };

        ts_ls = {
          cmd = [
            "${lib.getExe pkgs.typescript-language-server}"
            "--stdio"
          ];
          format = false;
          filetypes = [
            "typescript"
            "javascript"
            "javascriptreact"
            "typescriptreact"
            "vue"
          ];
          init_options = {
            hostInfo = "neovim";
            plugins = [
              {
                name = "@vue/typescript-plugin";
                location = "${pkgs.vue-language-server}/lib/language-tools/packages/language-server";
                languages = [ "vue" ];
                configNamespace = "typescript";
              }
            ];
          };
        };

        cssls.cmd = [
          "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server"
          "--stdio"
        ];
        html.cmd = [
          "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server"
          "--stdio"
        ];
        markdown_oxide.cmd = [ "${lib.getExe pkgs.markdown-oxide}" ];
        eslint.cmd = [
          "${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server"
          "--stdio"
        ];
        efm.cmd = [ "${lib.getExe pkgs.efm-langserver}" ];
        gopls.cmd = [ "${lib.getExe pkgs.gopls}" ];
        pyright.cmd = [
          "${pkgs.pyright}/bin/pyright-langserver"
          "--stdio"
        ];
        nixd.cmd = [ "${lib.getExe pkgs.nixd}" ];
        emmylua_ls.cmd = [ "${lib.getExe pkgs.emmylua-ls}" ];
        kotlin_language_server.cmd = [ "${lib.getExe pkgs.kotlin-language-server}" ];
        gleam.cmd = [
          "${lib.getExe pkgs.gleam}"
          "lsp"
        ];
        zls.cmd = [ "${lib.getExe pkgs.zls}" ];
        terraformls.cmd = [
          "${lib.getExe pkgs.terraform-ls}"
          "serve"
        ];
        tflint.cmd = [
          "${lib.getExe pkgs.tflint}"
          "--langserver"
        ];
        phpactor.cmd = [
          "${lib.getExe pkgs.phpactor}"
          "language-server"
        ];
        biome.cmd = [
          "${lib.getExe pkgs.biome}"
          "lsp-proxy"
        ];
        vue_ls.cmd = [
          "${lib.getExe pkgs.vue-language-server}"
          "--stdio"
        ];
        postgres_lsp.cmd = [ "${lib.getExe pkgs.postgres-language-server}" ];
      }
    }
  '';
}
