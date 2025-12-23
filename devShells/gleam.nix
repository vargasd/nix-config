{ pkgs, helpers }:
pkgs.mkShell {
  packages = with pkgs; [
    erlang
    gleam
  ];

  SAM_LSP_CONFIGS = helpers.extendJsonEnvVar pkgs "SAM_LSP_CONFIGS" {
    gleam = { };
    efm.settings.languages.gleam = [
      {
        formatCommand = "gleam format --stdin";
        formatStdin = true;
      }
    ];
  };
}
