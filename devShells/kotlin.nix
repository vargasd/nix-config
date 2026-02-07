{ pkgs, helpers }:
pkgs.mkShell {
  packages = with pkgs; [
    jdk21_headless
    kotlin
    kotlin-language-server
    ktfmt
    ktlint
  ];

  SAM_LSP_CONFIGS = helpers.extendJsonEnvVar pkgs "SAM_LSP_CONFIGS" {
    kotlin_language_server = { };
    efm.settings.languages.kotlin = [
      {
        prefix = "ktlint";
        lintSource = "ktlint";
        lintCommand = "--no-color --stdin-filename '\${INPUT}' --stdin";
        lintStdin = true;
        lintFormats = [
          "%\\s%#%l:%c %# %trror  %m"
          "%\\s%#%l:%c %# %tarning  %m"
        ];
        lintIgnoreExitCode = true;
        formatCommand = "ktfmt -";
        formatStdin = true;
      }
    ];
  };
}
