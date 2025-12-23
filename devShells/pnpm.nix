{ pkgs, helpers }:
pkgs.mkShell {
  packages = with pkgs; [
    pnpm
  ];
}
