{ pkgs, helpers }:
pkgs.mkShell {
  packages = with pkgs; [
    clang
    clang-tools
  ];

  SAM_LSP_CONFIGS = helpers.extendJsonEnvVar pkgs "SAM_LSP_CONFIGS" {
    clangd = { };
  };
}
