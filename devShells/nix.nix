{ pkgs, helpers }:
pkgs.mkShell {
  packages = with pkgs; [
    nixd
    nixfmt
  ];

  SAM_LSP_CONFIGS = helpers.extendJsonEnvVar pkgs "SAM_LSP_CONFIGS" {
    nixd = { };
    efm.settings.languages.nix = [
      {
        formatCommand = "nixfmt";
        formatStdin = true;
        rootMarkers = [
          "flake.nix"
          "shell.nix"
          "default.nix"
        ];
      }
    ];
  };
}
