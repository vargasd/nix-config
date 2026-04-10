{ pkgs, ... }:
{
  packages = with pkgs; [
    uv
    pyright
    ruff
  ];

  lspConfig = {
    pyright = { };

    efm.settings.languages.python = [
      {
        formatCommand = "ruff format --no-cache -";
        formatStdin = true;
        rootMarkers = [
          "pyproject.toml"
          "ruff.toml"
          ".ruff.toml"
        ];
      }
    ];
  };
}
