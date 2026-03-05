{ pkgs, ... }:
{
  packages = with pkgs; [
    jdk21_headless
    kotlin
    kotlin-language-server
    ktfmt
    ktlint
  ];

  lspConfig = {
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
