{ pkgs, helpers }:
pkgs.mkShell {
  packages = with pkgs; [
    phpactor
    php
  ];

  SAM_LSP_CONFIGS = helpers.extendJsonEnvVar pkgs "SAM_LSP_CONFIGS" {
    phpactor = { };
  };
}
