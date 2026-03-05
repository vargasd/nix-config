{ pkgs, ... }:
{
  packages = with pkgs; [
    nixd
    nixfmt
  ];

  lspConfig = {
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
