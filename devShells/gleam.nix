pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    erlang
    gleam
  ];
}
