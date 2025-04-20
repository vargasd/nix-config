pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    ruby
  ];
}
