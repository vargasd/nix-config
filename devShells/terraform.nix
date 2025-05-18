pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    opentofu
    terraform-ls
  ];
  shellHook = ''
    alias terraform=tofu
  '';
}
