pkgs: {
  packages = with pkgs; [
    opentofu
    terraform-ls
  ];
  commands = [
    {
      name = "terraform";
      command = "tofu";
    }
  ];
}
