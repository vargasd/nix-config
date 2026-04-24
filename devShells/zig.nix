{ pkgs, ... }:
{
  packages = with pkgs; [
    zig
    zls
  ];

  lspConfig = {
    zls = { };
    efm.settings.languages.zig = [
      {
        formatCommand = "zig fmt --sdtin";
        formatStdin = true;
      }
    ];
  };
}
