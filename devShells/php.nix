pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    phpactor
    php
  ];
}
