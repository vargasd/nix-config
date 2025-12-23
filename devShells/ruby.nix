{ pkgs, helpers }:
pkgs.mkShell {
  packages = with pkgs; [
    ruby
    bundler
  ];
}
