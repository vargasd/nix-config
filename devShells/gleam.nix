{ pkgs, ... }:
{
  packages = with pkgs; [
    erlang
    gleam
  ];

  lspConfig = {
    gleam = { };
    efm.settings.languages.gleam = [
      {
        formatCommand = "gleam format --stdin";
        formatStdin = true;
      }
    ];
  };
}
