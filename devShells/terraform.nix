pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    terraform
    terraform-ls
    tflint
  ];
}
