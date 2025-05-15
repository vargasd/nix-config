pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    pnpm
  ];
}
